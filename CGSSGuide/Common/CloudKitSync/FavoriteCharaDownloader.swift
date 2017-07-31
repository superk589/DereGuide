//
//  FavoriteCharaDownloader.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/27.
//  Copyright © 2017年 zzk. All rights reserved.
//

import CoreData

/// download the newest remote units and re
final class FavoriteCharaDownloader: ChangeProcessor {
    
    typealias Element = FavoriteChara
    
    var remote: FavoriteCharasRemote
    
    init(remote: FavoriteCharasRemote) {
        self.remote = remote
    }
    
    func setup(for context: ChangeProcessorContext) {
        remote.setupSubscription()
    }
    
    func processChangedLocalObjects(_ objects: [NSManagedObject], in context: ChangeProcessorContext) {
        // no-op
    }
    
    func processRemoteChanges<T>(_ changes: [RemoteRecordChange<T>], in context: ChangeProcessorContext, completion: () -> ()) {
        var creates: [RemoteFavoriteChara] = []
        var deletionIDs: [RemoteIdentifier] = []
        var updates: [RemoteFavoriteChara] = []
        for change in changes {
            switch change {
            case .insert(let r) where r is RemoteFavoriteChara:
                creates.append(r as! RemoteFavoriteChara)
            case .delete(let id):
                deletionIDs.append(id)
            case .update(let r) where r is RemoteFavoriteChara:
                updates.append(r as! RemoteFavoriteChara)
            default:
                continue
            }
        }
        insert(creates, in: context)
        deleteFavoriteCharas(with: deletionIDs, in: context)
        if Config.cloudKitDebug && creates.count + updates.count > 0 {
            print("Favorite Chara remote fetch inserts: \(creates.count) and updates: \(updates.count)")
        }
        context.delayedSaveOrRollback()
        completion()
    }
    
    func fetchLatestRemoteRecords(in context: ChangeProcessorContext) {
        remote.fetchLatestRecords(completion: { (remoteFavoriteCharas) in
            self.insert(remoteFavoriteCharas, in: context)
            self.reserve(remoteFavoriteCharas, in: context)
        })
    }
    
    func entityAndPredicateForLocallyTrackedObjects(in context: ChangeProcessorContext) -> EntityAndPredicate<NSManagedObject>? {
        return nil
    }
    
}


extension FavoriteCharaDownloader {
    
    fileprivate func deleteFavoriteCharas(with ids: [RemoteIdentifier], in context: ChangeProcessorContext) {
        guard !ids.isEmpty else { return }
        context.perform {
            let objects = FavoriteChara.fetch(in: context.managedObjectContext) { (request) -> () in
                request.predicate = FavoriteChara.predicateForRemoteIdentifiers(ids)
            }
            if Config.cloudKitDebug && objects.count > 0 {
                print("delete \(objects.count) local favorite chara from remote fetch")
            }
            objects.forEach { $0.markForLocalDeletion() }
        }
    }
    
    fileprivate func reserve(_ reserves: [RemoteFavoriteChara], in context: ChangeProcessorContext) {
        context.perform {
            let remoteRemoveds = { () -> [RemoteIdentifier] in
                let ids = reserves.map { $0.id }
                let favoriteCharas = FavoriteChara.fetch(in: context.managedObjectContext) { request in
                    request.predicate = FavoriteChara.predicateForNotInRemoteIdentifiers(ids)
                    request.returnsObjectsAsFaults = false
                }
                return favoriteCharas.map { $0.remoteIdentifier }.flatMap { $0 }
            }()
            
            // delete those have no remote records but left in local database
            self.deleteFavoriteCharas(with: remoteRemoveds, in: context)
            context.delayedSaveOrRollback()
        }
    }
    
    fileprivate func insert(_ remoteFavoriteChara: RemoteFavoriteChara, into context: ChangeProcessorContext) {
        remoteFavoriteChara.insert(into: context.managedObjectContext) { success in
            if success {
                context.delayedSaveOrRollback()
            } else {
                self.retryAfter(in: context, task: {
                    self.insert(remoteFavoriteChara, into: context)
                })
            }
        }
    }
    
    fileprivate func insert(_ inserts: [RemoteFavoriteChara], in context: ChangeProcessorContext) {
        context.perform {
            let existingFavoriteCharas = { () -> [RemoteIdentifier: FavoriteChara] in
                let ids = inserts.map { $0.id }
                let favoriteCharas = FavoriteChara.fetch(in: context.managedObjectContext) { request in
                    request.predicate = FavoriteChara.predicateForRemoteIdentifiers(ids)
                    request.returnsObjectsAsFaults = false
                }
                var result: [RemoteIdentifier: FavoriteChara] = [:]
                for favoriteChara in favoriteCharas {
                    result[favoriteChara.remoteIdentifier!] = favoriteChara
                }
                return result
            }()
            
            for remoteFavoriteChara in inserts {
                guard existingFavoriteCharas[remoteFavoriteChara.id] == nil else { continue }
                self.insert(remoteFavoriteChara, into: context)
            }
        }
    }
    
}



