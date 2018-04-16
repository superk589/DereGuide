//
//  MemberUploader.swift
//  DereGuide
//
//  Created by zzk on 2017/7/19.
//  Copyright © 2017 zzk. All rights reserved.
//

import CoreData

final class MemberUploader: ElementChangeProcessor {
    
    typealias Element = Member
    
    var remote: MembersRemote
    
    init(remote: MembersRemote) {
        self.remote = remote
    }
    
    var elementsInProgress = InProgressTracker<Member>()
    
    func setup(for context: ChangeProcessorContext) {
        // no-op
    }
    
    func processChangedLocalElements(_ objects: [Member], in context: ChangeProcessorContext) {
        processInsertedMembers(objects, in: context)
    }
    
    func processRemoteChanges<T>(_ changes: [RemoteRecordChange<T>], in context: ChangeProcessorContext, completion: () -> ()) {
        completion()
    }
    
    func fetchLatestRemoteRecords(in context: ChangeProcessorContext) {
        // no-op
    }
    
    var predicateForLocallyTrackedElements: NSPredicate {
        let predicate = NSPredicate(format: "%K.%K != nil", #keyPath(Member.participatedUnit), #keyPath(Unit.remoteIdentifier))
        return NSCompoundPredicate.init(andPredicateWithSubpredicates: [Member.waitingForUploadPredicate, predicate])
    }
}

extension MemberUploader {
    
    fileprivate func processInsertedMembers(_ insertions: [Member], in context: ChangeProcessorContext) {
        remote.upload(insertions) { (remoteMembers, error) in
            context.perform {
                guard !(error?.isPermanent ?? false) else {
                    // Since the error was permanent, delete these objects:
                    insertions.forEach { $0.markForLocalDeletion() }
                    self.elementsInProgress.markObjectsAsComplete(insertions)
                    return
                }
                for member in insertions {
                    guard let remoteMember = remoteMembers.first(where: { member.createdAt == $0.localCreatedAt }) else { continue }
                    member.creatorID = remoteMember.creatorID
                    member.remoteIdentifier = remoteMember.id
                }
                if Config.cloudKitDebug && insertions.count > 0 {
                    print("member uploader: upload \(insertions.count) success \(insertions.filter { $0.remoteIdentifier != nil }.count)")
                }
                context.delayedSaveOrRollback()
                self.elementsInProgress.markObjectsAsComplete(insertions)                
            }
        }
    }
    
}
