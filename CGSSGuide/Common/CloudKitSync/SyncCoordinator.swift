//
//  RemoteSync.swift
//  CGSSGuide
//
//  Created by Daniel Eggert on 22/05/2015.
//  Copyright (c) 2015 objc.io. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

public protocol CloudKitNotificationDrain {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
}


private let RemoteTypeEnvKey = "CloudKitRemote"


/// This is the central class that coordinates synchronization with the remote backend.
///
/// This classs does not have any model specific knowledge. It relies on multiple `ChangeProcessor` instances to process changes or communicate with the remote. Change processors have model-specific knowledge.
///
/// The change processors (`ChangeProcessor`) each have 1 specific aspect of syncing as their role. In our case there are three: one for uploading moods, one for downloading moods, and one for removing moods.
///
/// The `SyncCoordinator` is mostly single-threaded by design. This allows for the code to be relatively simple. All sync code runs on the queue of the `syncContext`. Entry points that may run on another queue **must** switch onto that context's queue using `perform(_:)`.
///
/// Note that inside this class we use `perform(_:)` in lieu of `dispatch_async()` to make sure all work is done on the sync context's queue. Adding asynchronous work to a dispatch group makes it easier to test. We can easily wait for all code to be completed by waiting on that group.
///
/// This class uses the `SyncContextType` and `ApplicationActiveStateObserving` protocols.
public final class SyncCoordinator {

    static let shared = SyncCoordinator(viewContext: CoreDataStack.default.viewContext, syncContext: CoreDataStack.default.syncContext)
    
    internal typealias ApplicationDidBecomeActive = () -> ()

    let viewContext: NSManagedObjectContext
    let syncContext: NSManagedObjectContext
    let syncGroup: DispatchGroup = DispatchGroup()

    let membersRemote: MembersRemote
    let unitsRemote: UnitsRemote
    let favoriteCardsRemote: FavoriteCardsRemote
    let favoriteCharasRemote: FavoriteCharasRemote
    
    fileprivate var observerTokens: [NSObjectProtocol] = [] //< The tokens registered with NotificationCenter
    let changeProcessors: [ChangeProcessor] //< The change processors for upload, download, etc.
    var teardownFlag = atomic_flag()

    private init(viewContext: NSManagedObjectContext, syncContext: NSManagedObjectContext) {
        self.membersRemote = MembersRemote()
        self.unitsRemote = UnitsRemote()
        self.favoriteCardsRemote = FavoriteCardsRemote()
        self.favoriteCharasRemote = FavoriteCharasRemote()
        
        self.viewContext = viewContext
        self.syncContext = syncContext
        syncContext.name = "SyncCoordinator"
        syncContext.mergePolicy = CloudKitMergePolicy(mode: .remote)
        
        // Member in remote has a reference of .deleteSelf action, so Member doesn't need a remover
        // local Unit need all of the 6 members to create, Member is created when Unit is downloaded by fetching in CloudKit using the CKReference on remote Member, so Member downloader only responsible for update remote changes
        changeProcessors = [UnitUploader(remote: unitsRemote),
                            UnitDownloader(remote: unitsRemote),
                            MemberDownloader(remote: membersRemote),
                            UnitRemover(remote: unitsRemote),
                            MemberUploader(remote: membersRemote),
                            UnitModifier(remote: unitsRemote),
                            MemberModifier(remote: membersRemote),
                            FavoriteCardUploader(remote: favoriteCardsRemote),
                            FavoriteCardDownloader(remote: favoriteCardsRemote),
                            FavoriteCardRemover(remote: favoriteCardsRemote),
                            FavoriteCharaUploader(remote: favoriteCharasRemote),
                            FavoriteCharaDownloader(remote: favoriteCharasRemote),
                            FavoriteCharaRemover(remote: favoriteCharasRemote)
        ]
        setup()
    }

    /// The `tearDown` method must be called in order to stop the sync coordinator.
    public func tearDown() {
        guard !atomic_flag_test_and_set(&teardownFlag) else { return }
        perform {
            self.removeAllObserverTokens()
        }
    }

    deinit {
        guard atomic_flag_test_and_set(&teardownFlag) else { fatalError("deinit called without tearDown() being called.") }
        // We must not call tearDown() at this point, because we can not call async code from within deinit.
        // We want to be able to call async code inside tearDown() to make sure things run on the right thread.
    }

    fileprivate func setup() {
        self.perform {
            // All these need to run on the same queue, since they're modifying `observerTokens`
            self.unitsRemote.fetchUserID { self.viewContext.userID = $0?.recordName }
            self.setupContexts()
            self.setupChangeProcessors()
            self.setupApplicationActiveNotifications()
        }
    }

}


extension SyncCoordinator: CloudKitNotificationDrain {
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        perform {
            self.fetchNewRemoteData()
        }
    }
    
}


// MARK: - Context Owner -

extension SyncCoordinator : ContextOwner {
    
    /// The sync coordinator holds onto tokens used to register with the NotificationCenter.
    func addObserverToken(_ token: NSObjectProtocol) {
        observerTokens.append(token)
    }
    
    func removeAllObserverTokens() {
        observerTokens.removeAll()
    }

    func processChangedLocalObjects(_ objects: [NSManagedObject]) {
        for cp in changeProcessors {
            cp.processChangedLocalObjects(objects, in: self)
        }
    }
    
    fileprivate func processChangedLocalObjects(_ objects: [NSManagedObject], using processor: ChangeProcessor) {
        processor.processChangedLocalObjects(objects, in: self)
    }
    
}


// MARK: - Context -


extension SyncCoordinator: ChangeProcessorContext {
    
    /// This is the context that the sync coordinator, change processors, and other sync components do work on.
    var managedObjectContext: NSManagedObjectContext {
        return syncContext
    }

    /// This switches onto the sync context's queue. If we're already on it, it will simply run the block.
    func perform(_ block: @escaping () -> ()) {
        syncContext.perform(group: syncGroup, block: block)
    }

    func perform<A,B>(_ block: @escaping (A,B) -> ()) -> (A,B) -> () {
        return { (a: A, b: B) -> () in
            self.perform {
                block(a, b)
            }
        }
    }

    func perform<A,B,C>(_ block: @escaping (A,B,C) -> ()) -> (A,B,C) -> () {
        return { (a: A, b: B, c: C) -> () in
            self.perform {
                block(a, b, c)
            }
        }
    }

    func delayedSaveOrRollback() {
        managedObjectContext.delayedSaveOrRollback(group: syncGroup)
    }
    
}


// MARK: Setup
extension SyncCoordinator {
    
    fileprivate func setupChangeProcessors() {
        for cp in self.changeProcessors {
            cp.setup(for: self)
        }
    }
    
}

// MARK: - Active & Background -

extension SyncCoordinator: ApplicationActiveStateObserving {
    
    func applicationDidFinishLaunching() {
        fetchRemoteDataForApplicationDidFinishLaunching()
    }
    
    func applicationDidBecomeActive() {
        fetchLocallyTrackedObjects()
        fetchRemoteDataForApplicationDidBecomeActive()
    }

    func applicationDidEnterBackground() {
        syncContext.refreshAllObjects()
    }

//    fileprivate func fetchLocallyTrackedObjects() {
//        self.perform {
//            // TODO: Could optimize this to only execute a single fetch request per entity.
//            var objects: Set<NSManagedObject> = []
//            for cp in self.changeProcessors {
//                guard let entityAndPredicate = cp.entityAndPredicateForLocallyTrackedObjects(in: self) else { continue }
//                let request = entityAndPredicate.fetchRequest
//                request.returnsObjectsAsFaults = false
//
//                let result = try! self.syncContext.fetch(request)
//                objects.formUnion(result)
//
//            }
//            self.processChangedLocalObjects(Array(objects))
//        }
//    }

    fileprivate func fetchLocallyTrackedObjects() {
        self.perform {
            // TODO: Could optimize this to only execute a single fetch request per entity.
            for cp in self.changeProcessors {
                guard let entityAndPredicate = cp.entityAndPredicateForLocallyTrackedObjects(in: self) else { continue }
                let request = entityAndPredicate.fetchRequest
                request.returnsObjectsAsFaults = false

                let result = try! self.syncContext.fetch(request)

                self.processChangedLocalObjects(result, using: cp)
            }
        }
    }

}


// MARK: - Remote -

extension SyncCoordinator {
    
    fileprivate func fetchRemoteDataForApplicationDidBecomeActive() {
        self.fetchNewRemoteData()
    }
    
    fileprivate func fetchRemoteDataForApplicationDidFinishLaunching() {
        self.fetchLatestRemoteData()
    }

    fileprivate func fetchLatestRemoteData() {
        perform { 
            for changeProcessor in self.changeProcessors {
                changeProcessor.fetchLatestRemoteRecords(in: self)
                self.delayedSaveOrRollback()
            }
        }
    }
    
    fileprivate func fetchNewRemoteData() {
        
        fetchNewRemoteData(using: unitsRemote)
        fetchNewRemoteData(using: membersRemote)
        fetchNewRemoteData(using: favoriteCardsRemote)
        fetchNewRemoteData(using: favoriteCharasRemote)
        
    }
    
    fileprivate func fetchNewRemoteData<T: Remote>(using remote: T) {
        remote.fetchNewRecords { (changes, callback) in
            self.processRemoteChanges(changes) {
                self.perform {
                    self.managedObjectContext.delayedSaveOrRollback(group: self.syncGroup) { success in
                        callback(success)
                    }
                }
            }
        }
    }
    
    fileprivate func processRemoteChanges<T>(_ changes: [RemoteRecordChange<T>], completion: @escaping () -> ()) {
        self.changeProcessors.asyncForEach(completion: completion) { changeProcessor, innerCompletion in
            perform {
                changeProcessor.processRemoteChanges(changes, in: self, completion: innerCompletion)
            }
        }
    }
}

