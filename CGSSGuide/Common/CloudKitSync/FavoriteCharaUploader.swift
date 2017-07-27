//
//  FavoriteCharaUploader.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/27.
//  Copyright © 2017年 zzk. All rights reserved.
//

import CoreData

/// use local favorite Chara to create remote favorite Chara
final class FavoriteCharaUploader: ElementChangeProcessor {
    
    typealias Element = FavoriteChara
    
    var remote: FavoriteCharasRemote
    
    init(remote: FavoriteCharasRemote) {
        self.remote = remote
    }
    
    var elementsInProgress = InProgressTracker<FavoriteChara>()
    
    func setup(for context: ChangeProcessorContext) {
        // no-op
    }
    
    func processChangedLocalElements(_ objects: [FavoriteChara], in context: ChangeProcessorContext) {
        processInsertedFavoriteCharas(objects, in: context)
    }
    
    func processRemoteChanges<T>(_ changes: [RemoteRecordChange<T>], in context: ChangeProcessorContext, completion: () -> ()) {
        completion()
    }
    
    func fetchLatestRemoteRecords(in context: ChangeProcessorContext) {
        // no-op
    }
    
    var predicateForLocallyTrackedElements: NSPredicate {
        return FavoriteChara.waitingForUploadPredicate
    }
}

extension FavoriteCharaUploader {
    
    fileprivate func processInsertedFavoriteCharas(_ insertions: [FavoriteChara], in context: ChangeProcessorContext) {
        remote.upload(insertions) { (remoteFavoriteCharas, error) in
            context.perform {
                guard !(error?.isPermanent ?? false) else {
                    // Since the error was permanent, delete these objects:
                    insertions.forEach { $0.markForLocalDeletion() }
                    self.elementsInProgress.markObjectsAsComplete(insertions)
                    return
                }
                // currently not retry for temporarily error
                
                // set unit remote id
                for favoriteChara in insertions {
                    guard let remoteFavoriteChara = remoteFavoriteCharas.first(where: { favoriteChara.createdAt == $0.localCreatedAt }) else { continue }
                    favoriteChara.creatorID = remoteFavoriteChara.creatorID
                    favoriteChara.remoteIdentifier = remoteFavoriteChara.id
                    if Config.cloudKitDebug && insertions.count > 0 {
                        print("upload unit \(favoriteChara.remoteIdentifier!)")
                    }
                }
                context.delayedSaveOrRollback()
                if Config.cloudKitDebug && insertions.count > 0 {
                    print("upload \(insertions.count) units, success \(insertions.filter { $0.remoteIdentifier != nil }.count)")
                }
                self.elementsInProgress.markObjectsAsComplete(insertions)
            }
        }
    }
    
}



