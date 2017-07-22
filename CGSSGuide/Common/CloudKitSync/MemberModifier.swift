//
//  MemberModifier.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/21.
//  Copyright © 2017年 zzk. All rights reserved.
//

import CoreData

final class MemberModifier: ElementChangeProcessor {
    
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
        processLocalModifiedMembers(objects, in: context)
        print("update remote members: \(objects.count)")
    }
    
    func processRemoteChanges<T>(_ changes: [RemoteRecordChange<T>], in context: ChangeProcessorContext, completion: () -> ()) {
        completion()
    }
    
    func fetchLatestRemoteRecords(in context: ChangeProcessorContext) {
        // no-op
    }
    
    var predicateForLocallyTrackedElements: NSPredicate {
        return Member.waitingForRemoteModificationPredicate
    }
}

extension MemberModifier {
    
    fileprivate func processLocalModifiedMembers(_ members: [Member], in context: ChangeProcessorContext) {
        remote.modify(members, modification: { (records, completion) in
            context.perform {
                for record in records {
                    let member: Member! = members.first { $0.remoteIdentifier == record.recordID.recordName }
                    let localRecord = member.toCKRecord()
                    localRecord.allKeys().forEach {
                        record[$0] = localRecord[$0]
                    }
                }
                self.elementsInProgress.markObjectsAsComplete(members)
                completion()
            }
        }) { (remoteMembers, error) in
            context.perform {
                guard !(error?.isPermanent ?? false) else {
                    // Since the error was permanent, delete these objects:
                    members.forEach { $0.markForLocalDeletion() }
                    self.elementsInProgress.markObjectsAsComplete(members)
                    return
                }
                for member in members {
                    guard let _ = remoteMembers.first(where: { member.remoteIdentifier == $0.id }) else { continue }
                    member.unmarkForRemoteModification()
                }
                context.delayedSaveOrRollback()
                self.elementsInProgress.markObjectsAsComplete(members)
            }
        }
    }
    
}
