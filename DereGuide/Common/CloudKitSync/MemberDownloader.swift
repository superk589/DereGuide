//
//  MemberDownloader.swift
//  DereGuide
//
//  Created by zzk on 2017/7/22.
//  Copyright © 2017 zzk. All rights reserved.
//

import CoreData

final class MemberDownloader: ChangeProcessor {
    
    typealias Element = Member
    
    var remote: MembersRemote
    
    init(remote: MembersRemote) {
        self.remote = remote
    }
    
    func setup(for context: ChangeProcessorContext) {
        remote.setupSubscription()
    }
    
    func processChangedLocalObjects(_ objects: [NSManagedObject], in context: ChangeProcessorContext) {
        // no-op
    }
    
    func processRemoteChanges<T>(_ changes: [RemoteRecordChange<T>], in context: ChangeProcessorContext, completion: () -> ()) {
        var creates: [RemoteMember] = []
        var deletionIDs: [RemoteIdentifier] = []
        var updates: [RemoteMember] = []
        for change in changes {
            switch change {
            case .insert(let r) where r is RemoteMember:
                creates.append(r as! RemoteMember)
            case .delete(let id):
                deletionIDs.append(id)
            case .update(let r) where r is RemoteMember:
                updates.append(r as! RemoteMember)
            default:
                continue
            }
        }
        insert(creates, in: context)
        deleteMembers(with: deletionIDs, in: context.managedObjectContext)
        update(updates, in: context)
        context.delayedSaveOrRollback()
        if Config.cloudKitDebug && updates.count > 0 {
            print("member downloader: update \(updates.count) from subscription")
        }
        completion()
    }
    
    func fetchLatestRemoteRecords(in context: ChangeProcessorContext) {
        remote.fetchLatestRecords(completion: { (remoteMembers, errors) in
            self.update(remoteMembers, in: context)
        })
    }
    
    func entityAndPredicateForLocallyTrackedObjects(in context: ChangeProcessorContext) -> EntityAndPredicate<NSManagedObject>? {
        return nil
    }
    
}

extension MemberDownloader {
    
    fileprivate func deleteMembers(with ids: [RemoteIdentifier], in context: NSManagedObjectContext) {
        // local units use cascade deletion relation to members, so no need to react to the remote deletion
    }
    
    fileprivate func insert(_ inserts: [RemoteMember], in context: ChangeProcessorContext) {
        // local units responsible for creating members
    }
    
    fileprivate func update(_ updates: [RemoteMember], in context: ChangeProcessorContext) {
        context.perform {
            let existingMembers = { () -> [RemoteIdentifier: Member] in
                let ids = updates.map { $0.id }
                let members = Member.fetch(in: context.managedObjectContext) { request in
                    request.predicate = Member.predicateForRemoteIdentifiers(ids)
                    request.returnsObjectsAsFaults = false
                }
                var result: [RemoteIdentifier: Member] = [:]
                for member in members {
                    result[member.remoteIdentifier!] = member
                }
                return result
            }()
            
            for remoteMember in updates {
                guard let member = existingMembers[remoteMember.id] else { continue }
                member.update(using: remoteMember)
                context.delayedSaveOrRollback()
            }
        }
    }
    
}
