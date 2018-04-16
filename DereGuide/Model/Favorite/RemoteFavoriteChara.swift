//
//  RemoteFavoriteChara.swift
//  DereGuide
//
//  Created by zzk on 2017/7/26.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

struct RemoteFavoriteChara: RemoteRecord {
    
    var id: String
    var creatorID: String
    var charaID: Int64
    var localCreatedAt: Date
}

extension RemoteFavoriteChara {
    
    static var recordType: String { return "FavoriteChara" }
    
    init?(record: CKRecord) {
        guard record.recordType == RemoteFavoriteChara.recordType else { return nil }
        guard
            let localCreatedAt = record["localCreatedAt"] as? Date,
            let charaID = record["charaID"] as? NSNumber,
            let creatorID = record.creatorUserRecordID?.recordName else {
                return nil
        }
        
        self.id = record.recordID.recordName
        self.creatorID = creatorID
        self.localCreatedAt = localCreatedAt
        self.charaID = charaID.int64Value
    }
    
}

extension RemoteFavoriteChara {
    
    func insert(into context: NSManagedObjectContext, completion: @escaping (Bool) -> ()) {
        context.perform {
            let chara = FavoriteChara.insert(into: context, charaID: Int(self.charaID))
            chara.creatorID = self.creatorID
            chara.remoteIdentifier = self.id
            chara.createdAt = self.localCreatedAt
            completion(true)
        }
    }
    
}
