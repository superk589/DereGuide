//
//  UnitUploader.swift
//  CGSSGuide
//
//  Created by Daniel Eggert on 22/05/2015.
//  Copyright (c) 2015 objc.io. All rights reserved.
//

import CoreData

/// use local units to create remote unit
final class UnitUploader: ElementChangeProcessor {
    
    typealias Element = Unit
    
    var remote: UnitsRemote
    
    init(remote: UnitsRemote) {
        self.remote = remote
    }
    
    var elementsInProgress = InProgressTracker<Unit>()

    func setup(for context: ChangeProcessorContext) {
        // no-op
    }

    func processChangedLocalElements(_ objects: [Unit], in context: ChangeProcessorContext) {
        processInsertedUnits(objects, in: context)
    }

    func processRemoteChanges<T>(_ changes: [RemoteRecordChange<T>], in context: ChangeProcessorContext, completion: () -> ()) {
        completion()
    }

    func fetchLatestRemoteRecords(in context: ChangeProcessorContext) {
        // no-op
    }

    var predicateForLocallyTrackedElements: NSPredicate {
        return Unit.waitingForUploadPredicate
    }
}

extension UnitUploader {
    
    fileprivate func processInsertedUnits(_ insertions: [Unit], in context: ChangeProcessorContext) {
        remote.upload(insertions) { (remoteUnits, error) in
            context.perform {
                guard !(error?.isPermanent ?? false) else {
                    // Since the error was permanent, delete these objects:
                    insertions.forEach { $0.markForLocalDeletion() }
                    self.elementsInProgress.markObjectsAsComplete(insertions)
                    return
                }
                // currently not retry for temporarily error

                // set unit remote id
                for unit in insertions {
                    guard let remoteUnit = remoteUnits.first(where: { unit.createdAt == $0.localCreatedAt }) else { continue }
                    unit.creatorID = remoteUnit.creatorID
                    unit.remoteIdentifier = remoteUnit.id
                    if Config.cloudKitDebug && insertions.count > 0 {
                        print("upload unit \(unit.remoteIdentifier!)")
                    }
                }
                context.delayedSaveOrRollback()
                if Config.cloudKitDebug && insertions.count > 0 {
                    print("upload \(insertions.count) units, success \(insertions.filter { $0.remoteIdentifier != nil }.count)")
                }
                self.elementsInProgress.markObjectsAsComplete(insertions)
            }
        }
    }
    
}

