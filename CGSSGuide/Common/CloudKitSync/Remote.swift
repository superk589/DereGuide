//
//  Remote.swift
//  CGSSGuide
//
//  Created by Florian on 21/09/15.
//  Copyright © 2015 objc.io. All rights reserved.
//

import CoreData
import CloudKit

enum RemoteRecordChange<T: RemoteRecord> {
    case insert(T)
    case update(T)
    case delete(RemoteIdentifier)
}

enum RemoteError {
    case permanent([RemoteIdentifier])
    case temporary

    var isPermanent: Bool {
        switch self {
        case .permanent: return true
        default: return false
        }
    }
}

extension RemoteError {
    fileprivate init?(cloudKitError: Error?) {
        guard let error = cloudKitError as NSError? else { return nil }
        if error.permanentCloudKitError {
            self = .permanent(error.partiallyFailedRecordIDsWithPermanentError.map { $0.recordName })
        } else {
            self = .temporary
        }
    }
}

extension RemoteRecordChange {
    init?(change: CloudKitRecordChange) {
        switch change {
        case .created(let r):
            guard let remoteRecord = T(record: r) else { return nil }
            self = RemoteRecordChange.insert(remoteRecord)
        case .updated(let r):
            guard let remoteRecord = T(record: r) else { return nil }
            self = RemoteRecordChange.update(remoteRecord)
        case .deleted(let id):
            self = RemoteRecordChange.delete(id.recordName)
        }
    }
}

protocol Remote {
    associatedtype R: RemoteRecord
    associatedtype L: RemoteUploadable, RemoteDeletable
    
    var cloudKitContainer: CKContainer { get }
    static var subscriptionID: String { get }
    func setupSubscription()
    func fetchLatestRecords(completion: @escaping ([R]) -> ())
    func fetchNewRecords(completion: @escaping ([RemoteRecordChange<R>], @escaping (_ success: Bool) -> ()) -> ())
    func upload(_ locals: [L], completion: @escaping ([R], RemoteError?) -> ())
    func remove(_ locals: [L], completion: @escaping ([RemoteIdentifier], RemoteError?) -> ())
    func fetchUserID(completion: @escaping (CKRecordID?) -> ())
}

extension Remote {
    
    var cloudKitContainer: CKContainer {
        return CKContainer.default()
    }
    
    var defaultSortDescriptor: NSSortDescriptor {
        return NSSortDescriptor(key: "modifiedAt", ascending: false)
    }
    
    func predicateOfUser(_ userID: CKRecordID) -> NSPredicate {
        return NSPredicate(format: "creatorUserRecordID == %@", userID)
    }
    
    func setupSubscription() {
        fetchUserID { (userID) in
            guard let userID = userID else {
                return
            }
            let predicate = NSPredicate(format: "creatorUserRecordID == %@", userID)
            
            let info = CKNotificationInfo()
            info.shouldSendContentAvailable = true
            
            let subscription: CKSubscription
            
            if #available(iOS 10.0, *) {
                let options: CKQuerySubscriptionOptions = [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion]
                subscription = CKQuerySubscription(recordType: RemoteUnit.recordType, predicate: predicate, subscriptionID: UnitsRemote.subscriptionID, options: options)
            } else {
                subscription = CKSubscription(recordType: RemoteUnit.recordType, predicate: predicate, subscriptionID: UnitsRemote.subscriptionID, options: [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion])
            }
            subscription.notificationInfo = info
            let op = CKModifySubscriptionsOperation(subscriptionsToSave: [subscription], subscriptionIDsToDelete: [])
            op.modifySubscriptionsCompletionBlock = { (foo, bar, error: Error?) -> () in
                if let e = error { print("Failed to modify subscription: \(e)") }
            }
            self.cloudKitContainer.publicCloudDatabase.add(op)
        }
    }

    func fetchNewRecords(completion: @escaping ([RemoteRecordChange<R>], @escaping (_ success: Bool) -> ()) -> ()) {
        cloudKitContainer.fetchAllPendingNotifications(changeToken: nil, subscriptionID: Self.subscriptionID) { changeReasons, error, callback in
            guard error == nil else { return completion([], { _ in }) } // TODO We should handle this case with e.g. a clean refetch
            guard changeReasons.count > 0 else { return completion([], callback) }
            self.cloudKitContainer.publicCloudDatabase.fetchRecords(for: changeReasons) { changes, error in
                completion(changes.map { RemoteRecordChange(change: $0) }.flatMap { $0 }, callback)
            }
        }
    }
    
    func fetchRecordsWith(_ predicates: [NSPredicate], _ sortDescriptors: [NSSortDescriptor], completion: @escaping ([R]) -> ()) {
        let query = CKQuery(recordType: "Unit", predicate: NSCompoundPredicate(andPredicateWithSubpredicates: predicates))
        query.sortDescriptors = sortDescriptors
        let op = CKQueryOperation(query: query)
        //        op.resultsLimit = maximumNumberOfUnits
        op.fetchAggregateResults(in: self.cloudKitContainer.publicCloudDatabase, previousResults: []) { records, _ in
            completion(records.map { R(record: $0) }.flatMap { $0 })
        }
    }
    
    func fetchRecordsForCurrentUserWith(_ predicates: [NSPredicate], _ sortDescriptors: [NSSortDescriptor], completion: @escaping ([R]) -> ()) {
        fetchUserID { (userID) in
            guard let userID = userID else {
                completion([])
                return
            }
            var allPredicates = [self.predicateOfUser(userID)]
            allPredicates.append(contentsOf: predicates)
            self.fetchRecordsWith(allPredicates, sortDescriptors, completion: completion)
        }
    }
    
    func fetchUserID(completion: @escaping (CKRecordID?) -> ()) {
        cloudKitContainer.fetchUserRecordID { userRecordID, error in
            completion(userRecordID)
        }
    }
    
    func fetchLatestRecords(completion: @escaping ([R]) -> ()) {
        fetchUserID { (userID) in
            guard let userID = userID else {
                completion([])
                return
            }
            let query = CKQuery(recordType: "Unit", predicate: self.predicateOfUser(userID))
            query.sortDescriptors = [self.defaultSortDescriptor]
            let op = CKQueryOperation(query: query)
            //        op.resultsLimit = maximumNumberOfUnits
            op.fetchAggregateResults(in: self.cloudKitContainer.publicCloudDatabase, previousResults: []) { records, _ in
                completion(records.map { R(record: $0) }.flatMap { $0 })
            }
        }
    }
    
    func upload(_ locals: [L], completion: @escaping ([R], RemoteError?) -> ()) {
        let recordsToSave = locals.map { $0.toCKRecord() }
        let op = CKModifyRecordsOperation(recordsToSave: recordsToSave,
                                          recordIDsToDelete: nil)
        op.modifyRecordsCompletionBlock = { modifiedRecords, _, error in
            let remoteRecords = modifiedRecords?.map { R(record: $0) }.flatMap { $0 } ?? []
            let remoteError = RemoteError(cloudKitError: error)
            completion(remoteRecords, remoteError)
        }
        cloudKitContainer.publicCloudDatabase.add(op)
    }
    
    func remove(_ locals: [L], completion: @escaping ([RemoteIdentifier], RemoteError?) -> ()) {
        let recordIDsToDelete = locals.map { (l: L) -> CKRecordID in
            guard let name = l.remoteIdentifier else { fatalError("Must have a remote ID") }
            return CKRecordID(recordName: name)
        }
        let op = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDsToDelete)
        op.modifyRecordsCompletionBlock = { _, deletedRecordIDs, error in
            completion((deletedRecordIDs ?? []).map { $0.recordName }, RemoteError(cloudKitError: error))
        }
        cloudKitContainer.publicCloudDatabase.add(op)
    }
}

