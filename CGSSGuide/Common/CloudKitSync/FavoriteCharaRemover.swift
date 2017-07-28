//
//  FavoriteCharaRemover.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/27.
//  Copyright © 2017年 zzk. All rights reserved.
//

import CoreData

/// delete remote units when local units are deleted
final class FavoriteCharaRemover: ElementChangeProcessor {
    
    var remote: FavoriteCharasRemote
    
    init(remote: FavoriteCharasRemote) {
        self.remote = remote
    }
    
    var elementsInProgress = InProgressTracker<FavoriteChara>()
    
    func setup(for context: ChangeProcessorContext) {
        // no-op
    }
    
    func processChangedLocalElements(_ elements: [FavoriteChara], in context: ChangeProcessorContext) {
        processDeletedUnits(elements, in: context)
    }
    
    func processRemoteChanges<T>(_ changes: [RemoteRecordChange<T>], in context: ChangeProcessorContext, completion: () -> ()) {
        // no-op
        completion()
    }
    
    func fetchLatestRemoteRecords(in context: ChangeProcessorContext) {
        // no-op
    }
    
    var predicateForLocallyTrackedElements: NSPredicate {
        let marked = FavoriteChara.markedForRemoteDeletionPredicate
        let notDeleted = FavoriteChara.notMarkedForLocalDeletionPredicate
        return NSCompoundPredicate(andPredicateWithSubpredicates:[marked, notDeleted])
    }
}


extension FavoriteCharaRemover {
    
    fileprivate func processDeletedUnits(_ deletions: [FavoriteChara], in context: ChangeProcessorContext) {
        context.perform {
            let allObjects = Set(deletions)
            let localOnly = allObjects.filter { $0.remoteIdentifier == nil }
            let objectsToDeleteRemotely = Array(allObjects.subtracting(localOnly))
            if Config.cloudKitDebug {
                if localOnly.count > 0 {
                    print("delete local favorite charas \(localOnly.count)")
                }
                if objectsToDeleteRemotely.count > 0 {
                    print("delete remote favorite charas \(objectsToDeleteRemotely.count)")
                }
            }
            self.deleteLocally(Array(localOnly), context: context)
            self.deleteRemotely(objectsToDeleteRemotely, context: context)
        }
    }
    
    fileprivate func deleteLocally(_ deletions: [FavoriteChara], context: ChangeProcessorContext) {
        deletions.forEach { $0.markForLocalDeletion() }
    }
    
    fileprivate func deleteRemotely(_ deletions: [FavoriteChara], context: ChangeProcessorContext) {
        remote.remove(deletions, completion: context.perform { deletedRecordIDs, error in
            
            var deletedIDs = Set(deletedRecordIDs)
            if case .permanent(let ids)? = error {
                deletedIDs.formUnion(ids)
            }
            
            let toBeDeleted = deletions.filter { deletedIDs.contains($0.remoteIdentifier ?? "") }
            self.deleteLocally(toBeDeleted, context: context)
            // This will retry failures with non-permanent failures:
            if case .temporary(let interval)? = error {
                self.retryAfter(interval, in: context, task: {
                    self.didComplete(Array(deletions), in: context)
                })
            }
            
            context.delayedSaveOrRollback()
        })
    }
    
}



