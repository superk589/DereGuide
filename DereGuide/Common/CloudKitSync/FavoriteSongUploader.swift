//
//  FavoriteSongUploader.swift
//  DereGuide
//
//  Created by zzk on 29/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import CoreData

/// use local favorite Song to create remote favorite Song
final class FavoriteSongUploader: ElementChangeProcessor {
    
    typealias Element = FavoriteSong
    
    var remote: FavoriteSongsRemote
    
    init(remote: FavoriteSongsRemote) {
        self.remote = remote
    }
    
    var elementsInProgress = InProgressTracker<FavoriteSong>()
    
    func setup(for context: ChangeProcessorContext) {
        // no-op
    }
    
    func processChangedLocalElements(_ objects: [FavoriteSong], in context: ChangeProcessorContext) {
        processInsertedFavoriteSongs(objects, in: context)
    }
    
    func processRemoteChanges<T>(_ changes: [RemoteRecordChange<T>], in context: ChangeProcessorContext, completion: () -> ()) {
        completion()
    }
    
    func fetchLatestRemoteRecords(in context: ChangeProcessorContext) {
        // no-op
    }
    
    var predicateForLocallyTrackedElements: NSPredicate {
        return FavoriteSong.waitingForUploadPredicate
    }
}

extension FavoriteSongUploader {
    
    fileprivate func processInsertedFavoriteSongs(_ insertions: [FavoriteSong], in context: ChangeProcessorContext) {
        remote.upload(insertions) { (remoteFavoriteSongs, error) in
            context.perform {
                guard !(error?.isPermanent ?? false) else {
                    // Since the error was permanent, delete these objects:
                    insertions.forEach { $0.markForLocalDeletion() }
                    self.elementsInProgress.markObjectsAsComplete(insertions)
                    return
                }
                // currently not retry for temporarily error
                
                // set unit remote id
                for favoriteSong in insertions {
                    guard let remoteFavoriteSong = remoteFavoriteSongs.first(where: { favoriteSong.createdAt == $0.localCreatedAt }) else { continue }
                    favoriteSong.creatorID = remoteFavoriteSong.creatorID
                    favoriteSong.remoteIdentifier = remoteFavoriteSong.id
                }
                context.delayedSaveOrRollback()
                if Config.cloudKitDebug && insertions.count > 0 {
                    print("favorite song uploader: upload \(insertions.count) success \(insertions.filter { $0.remoteIdentifier != nil }.count)")
                }
                self.elementsInProgress.markObjectsAsComplete(insertions)
            }
        }
    }
    
}




