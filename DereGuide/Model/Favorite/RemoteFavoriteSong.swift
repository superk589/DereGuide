//
//  RemoteFavoriteSong.swift
//  DereGuide
//
//  Created by zzk on 11/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

struct RemoteFavoriteSong: RemoteRecord {
    
    var id: String
    var creatorID: String
    var musicID: Int64
    var localCreatedAt: Date
}

extension RemoteFavoriteSong {
    
    static var recordType: String { return "FavoriteSong" }
    
    init?(record: CKRecord) {
        guard record.recordType == RemoteFavoriteSong.recordType else { return nil }
        guard
            let localCreatedAt = record["localCreatedAt"] as? Date,
            let musicID = record["musicID"] as? NSNumber,
            let creatorID = record.creatorUserRecordID?.recordName else {
                return nil
        }
        
        self.id = record.recordID.recordName
        self.creatorID = creatorID
        self.localCreatedAt = localCreatedAt
        self.musicID = musicID.int64Value
    }
    
}

extension RemoteFavoriteSong {
    
    func insert(into context: NSManagedObjectContext, completion: @escaping (Bool) -> ()) {
        context.perform {
            let song = FavoriteSong.insert(into: context, musicID: Int(self.musicID))
            song.creatorID = self.creatorID
            song.remoteIdentifier = self.id
            song.createdAt = self.localCreatedAt
            completion(true)
        }
    }
    
}
