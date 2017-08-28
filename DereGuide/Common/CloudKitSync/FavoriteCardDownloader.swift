//
//  FavoriteCardDownloader.swift
//  DereGuide
//
//  Created by zzk on 2017/7/27.
//  Copyright © 2017年 zzk. All rights reserved.
//

import CoreData

/// download the newest remote units and re
final class FavoriteCardDownloader: ChangeProcessor {
    
    typealias Element = FavoriteCard
    
    var remote: FavoriteCardsRemote
    
    init(remote: FavoriteCardsRemote) {
        self.remote = remote
    }
    
    func setup(for context: ChangeProcessorContext) {
        remote.setupSubscription()
    }
    
    func processChangedLocalObjects(_ objects: [NSManagedObject], in context: ChangeProcessorContext) {
        // no-op
    }
    
    func processRemoteChanges<T>(_ changes: [RemoteRecordChange<T>], in context: ChangeProcessorContext, completion: () -> ()) {
        var creates: [RemoteFavoriteCard] = []
        var deletionIDs: [RemoteIdentifier] = []
//        var updates: [RemoteFavoriteCard] = []
        for change in changes {
            switch change {
            case .insert(let r) where r is RemoteFavoriteCard:
                creates.append(r as! RemoteFavoriteCard)
            case .delete(let id):
                deletionIDs.append(id)
//            case .update(let r) where r is RemoteFavoriteCard:
//                updates.append(r as! RemoteFavoriteCard)
            default:
                continue
            }
        }
        insert(creates, in: context)
        deleteFavoriteCards(with: deletionIDs, in: context)
        if Config.cloudKitDebug && creates.count > 0 {
            print("favorite card downloader: insert \(creates.count) from subscription")
        }
        context.delayedSaveOrRollback()
        completion()
    }
    
    func fetchLatestRemoteRecords(in context: ChangeProcessorContext) {
        remote.fetchLatestRecords(completion: { (remoteFavoriteCards, errors) in
            self.insert(remoteFavoriteCards, in: context)
            if errors.count == 0 {
                self.reserve(remoteFavoriteCards, in: context)
            }
        })
    }
    
    func entityAndPredicateForLocallyTrackedObjects(in context: ChangeProcessorContext) -> EntityAndPredicate<NSManagedObject>? {
        return nil
    }
    
}

extension FavoriteCardDownloader {
    
    fileprivate func deleteFavoriteCards(with ids: [RemoteIdentifier], in context: ChangeProcessorContext) {
        guard !ids.isEmpty else { return }
        context.perform {
            let objects = FavoriteCard.fetch(in: context.managedObjectContext) { (request) -> () in
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [FavoriteCard.predicateForRemoteIdentifiers(ids), FavoriteCard.notMarkedForLocalDeletionPredicate])
            }
            if Config.cloudKitDebug && objects.count > 0 {
                print("favorite card downloader: delete \(objects.count) from subscription")
            }
            objects.forEach { $0.markForLocalDeletion() }
        }
    }
    
    fileprivate func reserve(_ reserves: [RemoteFavoriteCard], in context: ChangeProcessorContext) {
        context.perform {
            let remoteRemoveds = { () -> [RemoteIdentifier] in
                let ids = reserves.map { $0.id }
                let favoriteCards = FavoriteCard.fetch(in: context.managedObjectContext) { request in
                    request.predicate = FavoriteCard.predicateForNotInRemoteIdentifiers(ids)
                    request.returnsObjectsAsFaults = false
                }
                return favoriteCards.map { $0.remoteIdentifier }.flatMap { $0 }
            }()
            
            // delete those have no remote records but left in local database
            self.deleteFavoriteCards(with: remoteRemoveds, in: context)
            context.delayedSaveOrRollback()
        }
    }
    
    fileprivate func insert(_ remoteFavoriteCard: RemoteFavoriteCard, into context: ChangeProcessorContext) {
        remoteFavoriteCard.insert(into: context.managedObjectContext) { success in
            if success {
                context.delayedSaveOrRollback()
            } else {
                self.retryAfter(in: context, task: {
                    self.insert(remoteFavoriteCard, into: context)
                })
            }
        }
    }
    
    fileprivate func insert(_ inserts: [RemoteFavoriteCard], in context: ChangeProcessorContext) {
        context.perform {
            let existingFavoriteCards = { () -> [RemoteIdentifier: FavoriteCard] in
                let ids = inserts.map { $0.id }
                let favoriteCards = FavoriteCard.fetch(in: context.managedObjectContext) { request in
                    request.predicate = FavoriteCard.predicateForRemoteIdentifiers(ids)
                    request.returnsObjectsAsFaults = false
                }
                var result: [RemoteIdentifier: FavoriteCard] = [:]
                for favoriteCard in favoriteCards {
                    result[favoriteCard.remoteIdentifier!] = favoriteCard
                }
                return result
            }()
            
            for remoteFavoriteCard in inserts {
                guard existingFavoriteCards[remoteFavoriteCard.id] == nil else { continue }
                self.insert(remoteFavoriteCard, into: context)
            }
        }
    }
    
}


