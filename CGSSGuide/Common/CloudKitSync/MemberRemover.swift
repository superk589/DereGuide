//
//  MemberRemover.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/19.
//  Copyright © 2017年 zzk. All rights reserved.
//

import CoreData

final class MemberRemover: ElementChangeProcessor {
    
    var remote: MembersRemote
    
    init(remote: MembersRemote) {
        self.remote = remote
    }
    
    var elementsInProgress = InProgressTracker<Member>()
    
    func setup(for context: ChangeProcessorContext) {
        // no-op
    }
    
    func processChangedLocalElements(_ elements: [Member], in context: ChangeProcessorContext) {
        processDeletedMembers(elements, in: context)
    }
    
    func processRemoteChanges<T>(_ changes: [RemoteRecordChange<T>], in context: ChangeProcessorContext, completion: () -> ()) {
        // no-op
        completion()
    }
    
    func fetchLatestRemoteRecords(in context: ChangeProcessorContext) {
        // no-op
    }
    
    var predicateForLocallyTrackedElements: NSPredicate {
        let marked = Member.markedForRemoteDeletionPredicate
        let notDeleted = Member.notMarkedForLocalDeletionPredicate
        return NSCompoundPredicate(andPredicateWithSubpredicates:[marked, notDeleted])
    }
}


extension MemberRemover {
    
    fileprivate func processDeletedMembers(_ deletions: [Member], in context: ChangeProcessorContext) {
        context.perform {
            let allObjects = Set(deletions)
            let localOnly = allObjects.filter { $0.remoteIdentifier == nil }
            let objectsToDeleteRemotely = Array(allObjects.subtracting(localOnly))
            self.deleteLocally(localOnly, context: context)
            self.deleteRemotely(objectsToDeleteRemotely, context: context)
        }
    }
    
    fileprivate func deleteLocally(_ deletions: [Member], context: ChangeProcessorContext) {
        deletions.forEach { $0.markForLocalDeletion() }
    }
    
    fileprivate func deleteRemotely(_ deletions: [Member], context: ChangeProcessorContext) {
        remote.remove(deletions, completion: context.perform { deletedRecordIDs, error in
            var deletedIDs = Set(deletedRecordIDs)
            if case .permanent(let ids)? = error {
                deletedIDs.formUnion(ids)
            }
            
            let toBeDeleted = deletions.filter { deletedIDs.contains($0.remoteIdentifier ?? "") }
            self.deleteLocally(toBeDeleted, context: context)
            // This will retry failures with non-permanent failures:
            self.didComplete(Array(deletions), in: context)
            context.delayedSaveOrRollback()
        })
    }
    
}
