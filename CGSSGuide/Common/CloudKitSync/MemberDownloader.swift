//
//  MemberDownloader.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/19.
//  Copyright © 2017年 zzk. All rights reserved.
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
                fatalError("change reason not implemented")
            }
        }
        insert(creates, into: context.context)
        deleteUnits(with: deletionIDs, in: context.context)
        update(updates, in: context.context)
        context.delayedSaveOrRollback()
        completion()
    }
    
    func fetchLatestRemoteRecords(in context: ChangeProcessorContext) {
        remote.fetchLatestRecords(completion: { (remoteMembers) in
            self.insert(remoteMembers, into: context.context)
            context.delayedSaveOrRollback()
        })
    }
    
    func entityAndPredicateForLocallyTrackedObjects(in context: ChangeProcessorContext) -> EntityAndPredicate<NSManagedObject>? {
        return nil
    }
    
}


extension MemberDownloader {
    
    fileprivate func deleteUnits(with ids: [RemoteIdentifier], in context: NSManagedObjectContext) {
        guard !ids.isEmpty else { return }
        context.perform {
            let members = Member.fetch(in: context) { (request) -> () in
                request.predicate = Member.predicateForRemoteIdentifiers(ids)
                request.returnsObjectsAsFaults = false
            }
            members.forEach { $0.markForLocalDeletion() }
        }
    }
    
    fileprivate func insert(_ remoteMembers: [RemoteMember], into context: NSManagedObjectContext) {
        context.perform {
            let existingMembers = { () -> [RemoteIdentifier: Member] in
                let ids = remoteMembers.map { $0.id }.flatMap { $0 }
                let members = Member.fetch(in: context) { request in
                    request.predicate = Member.predicateForRemoteIdentifiers(ids)
                    request.returnsObjectsAsFaults = false
                }
                var result: [RemoteIdentifier: Member] = [:]
                for member in members {
                    result[member.remoteIdentifier!] = member
                }
                return result
            }()
            
            for remoteMember in remoteMembers {
                guard existingMembers[remoteMember.id] == nil else { continue }
                remoteMember.insert(into: context)
            }
        }
    }
    
    fileprivate func update(_ updates: [RemoteMember], in context: NSManagedObjectContext) {
        
    }
    
}

