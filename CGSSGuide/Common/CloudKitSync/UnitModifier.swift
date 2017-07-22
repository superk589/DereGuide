//
//  UnitModifier.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/21.
//  Copyright © 2017年 zzk. All rights reserved.
//

import CoreData

/// modify remote units from changes of local units
final class UnitModifier: ElementChangeProcessor {
    
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
        processLocalModifiedUnits(objects, in: context)
        if Config.cloudKitDebug {
            print("update remote units: \(objects.count)")
        }
    }
    
    func processRemoteChanges<T>(_ changes: [RemoteRecordChange<T>], in context: ChangeProcessorContext, completion: () -> ()) {
        completion()
    }
    
    func fetchLatestRemoteRecords(in context: ChangeProcessorContext) {
        // no-op
    }
    
    var predicateForLocallyTrackedElements: NSPredicate {
        return Unit.waitingForRemoteModificationPredicate
    }
}

extension UnitModifier {
    
    fileprivate func processLocalModifiedUnits(_ units: [Unit], in context: ChangeProcessorContext) {
        remote.modify(units, modification: { (records, completion) in
            context.perform {
                for record in records {
                    let unit: Unit! = units.first { $0.remoteIdentifier == record.recordID.recordName }
                    let localRecord = unit.toCKRecord()
                    localRecord.allKeys().forEach {
                        record[$0] = localRecord[$0]
                    }
                }
                self.elementsInProgress.markObjectsAsComplete(units)
                completion()
            }
        }) { (remoteUnits, error) in
            context.perform {
                guard !(error?.isPermanent ?? false) else {
                    // Since the error was permanent, delete these objects:
                    units.forEach { $0.markForLocalDeletion() }
                    self.elementsInProgress.markObjectsAsComplete(units)
                    return
                }
                for unit in units {
                    guard let _ = remoteUnits.first(where: { unit.remoteIdentifier == $0.id }) else { continue }
                    unit.unmarkForRemoteModification()
                }
                context.delayedSaveOrRollback()
                self.elementsInProgress.markObjectsAsComplete(units)
            }
        }
    }
}


