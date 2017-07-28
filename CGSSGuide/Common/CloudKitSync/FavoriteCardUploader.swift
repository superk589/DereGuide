//
//  FavoriteCardUploader.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/27.
//  Copyright © 2017年 zzk. All rights reserved.
//

import CoreData

/// use local favorite card to create remote favorite card
final class FavoriteCardUploader: ElementChangeProcessor {
    
    typealias Element = FavoriteCard
    
    var remote: FavoriteCardsRemote
    
    init(remote: FavoriteCardsRemote) {
        self.remote = remote
    }
    
    var elementsInProgress = InProgressTracker<FavoriteCard>()
    
    func setup(for context: ChangeProcessorContext) {
        // no-op
    }
    
    func processChangedLocalElements(_ objects: [FavoriteCard], in context: ChangeProcessorContext) {
        processInsertedFavoriteCards(objects, in: context)
    }
    
    func processRemoteChanges<T>(_ changes: [RemoteRecordChange<T>], in context: ChangeProcessorContext, completion: () -> ()) {
        completion()
    }
    
    func fetchLatestRemoteRecords(in context: ChangeProcessorContext) {
        // no-op
    }
    
    var predicateForLocallyTrackedElements: NSPredicate {
        return FavoriteCard.waitingForUploadPredicate
    }
}

extension FavoriteCardUploader {
    
    fileprivate func processInsertedFavoriteCards(_ insertions: [FavoriteCard], in context: ChangeProcessorContext) {
        remote.upload(insertions) { (remoteFavoriteCards, error) in
            context.perform {
                guard !(error?.isPermanent ?? false) else {
                    // Since the error was permanent, delete these objects:
                    insertions.forEach { $0.markForLocalDeletion() }
                    self.elementsInProgress.markObjectsAsComplete(insertions)
                    return
                }
                // currently not retry for temporarily error
                
                // set unit remote id
                for favoriteCard in insertions {
                    guard let remoteFavoriteCard = remoteFavoriteCards.first(where: { favoriteCard.createdAt == $0.localCreatedAt }) else { continue }
                    favoriteCard.creatorID = remoteFavoriteCard.creatorID
                    favoriteCard.remoteIdentifier = remoteFavoriteCard.id
                    if Config.cloudKitDebug && insertions.count > 0 {
                        print("upload unit \(favoriteCard.remoteIdentifier!)")
                    }
                }
                context.delayedSaveOrRollback()
                if Config.cloudKitDebug && insertions.count > 0 {
                    print("upload \(insertions.count) favorite cards, success \(insertions.filter { $0.remoteIdentifier != nil }.count)")
                }
                self.elementsInProgress.markObjectsAsComplete(insertions)
            }
        }
    }
    
}


