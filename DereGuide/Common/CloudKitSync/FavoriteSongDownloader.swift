//
//  FavoriteSongDownloader.swift
//  DereGuide
//
//  Created by zzk on 29/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import CoreData

/// download the newest remote units and re
final class FavoriteSongDownloader: ChangeProcessor {
    
    typealias Element = FavoriteSong
    
    var remote: FavoriteSongsRemote
    
    init(remote: FavoriteSongsRemote) {
        self.remote = remote
    }
    
    func setup(for context: ChangeProcessorContext) {
        remote.setupSubscription()
    }
    
    func processChangedLocalObjects(_ objects: [NSManagedObject], in context: ChangeProcessorContext) {
        // no-op
    }
    
    func processRemoteChanges<T>(_ changes: [RemoteRecordChange<T>], in context: ChangeProcessorContext, completion: () -> ()) {
        var creates: [RemoteFavoriteSong] = []
        var deletionIDs: [RemoteIdentifier] = []
        //        var updates: [RemoteFavoriteSong] = []
        for change in changes {
            switch change {
            case .insert(let r) where r is RemoteFavoriteSong:
                creates.append(r as! RemoteFavoriteSong)
            case .delete(let id):
                deletionIDs.append(id)
                //            case .update(let r) where r is RemoteFavoriteSong:
            //                updates.append(r as! RemoteFavoriteSong)
            default:
                continue
            }
        }
        insert(creates, in: context)
        deleteFavoriteSongs(with: deletionIDs, in: context)
        if Config.cloudKitDebug && creates.count > 0 {
            print("favorite song downloader: insert \(creates.count) from subscription")
        }
        context.delayedSaveOrRollback()
        completion()
    }
    
    func fetchLatestRemoteRecords(in context: ChangeProcessorContext) {
        remote.fetchLatestRecords(completion: { (remoteFavoriteSongs, errors) in
            self.insert(remoteFavoriteSongs, in: context)
            if errors.count == 0 {
                self.reserve(remoteFavoriteSongs, in: context)
            }
        })
    }
    
    func entityAndPredicateForLocallyTrackedObjects(in context: ChangeProcessorContext) -> EntityAndPredicate<NSManagedObject>? {
        return nil
    }
    
}


extension FavoriteSongDownloader {
    
    fileprivate func deleteFavoriteSongs(with ids: [RemoteIdentifier], in context: ChangeProcessorContext) {
        guard !ids.isEmpty else { return }
        context.perform {
            let objects = FavoriteSong.fetch(in: context.managedObjectContext) { (request) -> () in
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [FavoriteSong.predicateForRemoteIdentifiers(ids), FavoriteSong.notMarkedForLocalDeletionPredicate])
            }
            if Config.cloudKitDebug && objects.count > 0 {
                print("favorite song downloader: delete \(objects.count) from subscription")
            }
            objects.forEach { $0.markForLocalDeletion() }
        }
    }
    
    fileprivate func reserve(_ reserves: [RemoteFavoriteSong], in context: ChangeProcessorContext) {
        context.perform {
            let remoteRemoveds = { () -> [RemoteIdentifier] in
                let ids = reserves.map { $0.id }
                let favoriteSongs = FavoriteSong.fetch(in: context.managedObjectContext) { request in
                    request.predicate = FavoriteSong.predicateForNotInRemoteIdentifiers(ids)
                    request.returnsObjectsAsFaults = false
                }
                return favoriteSongs.map { $0.remoteIdentifier }.compactMap { $0 }
            }()
            
            // delete those have no remote records but left in local database
            self.deleteFavoriteSongs(with: remoteRemoveds, in: context)
            context.delayedSaveOrRollback()
        }
    }
    
    fileprivate func insert(_ remoteFavoriteSong: RemoteFavoriteSong, into context: ChangeProcessorContext) {
        remoteFavoriteSong.insert(into: context.managedObjectContext) { success in
            if success {
                context.delayedSaveOrRollback()
            } else {
                self.retryAfter(in: context, task: {
                    self.insert(remoteFavoriteSong, into: context)
                })
            }
        }
    }
    
    fileprivate func insert(_ inserts: [RemoteFavoriteSong], in context: ChangeProcessorContext) {
        context.perform {
            let existingFavoriteSongs = { () -> [RemoteIdentifier: FavoriteSong] in
                let ids = inserts.map { $0.id }
                let favoriteSongs = FavoriteSong.fetch(in: context.managedObjectContext) { request in
                    request.predicate = FavoriteSong.predicateForRemoteIdentifiers(ids)
                    request.returnsObjectsAsFaults = false
                }
                var result: [RemoteIdentifier: FavoriteSong] = [:]
                for favoriteSong in favoriteSongs {
                    result[favoriteSong.remoteIdentifier!] = favoriteSong
                }
                return result
            }()
            
            for remoteFavoriteSong in inserts {
                guard existingFavoriteSongs[remoteFavoriteSong.id] == nil else { continue }
                self.insert(remoteFavoriteSong, into: context)
            }
        }
    }
    
}




