//
//  RemoteMember.swift
//  DereGuide
//
//  Created by zzk on 2017/7/13.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

struct RemoteMember: RemoteRecord {    

    var id: String
    var creatorID: String
    var localCreatedAt: Date
    var localModifiedAt: Date

    var cardID: Int64
    var skillLevel: Int64
    var danceLevel: Int64
    var vocalLevel: Int64
    var visualLevel: Int64
    var lifeLevel: Int64
    var skillPotentialLevel: Int64
    var participatedPosition: Int64
    var participatedUnit: CKRecord.Reference
    
}

extension RemoteMember {
    
    static var recordType: String { return "Member" }
    
    init?(record: CKRecord) {
        guard record.recordType == RemoteMember.recordType else { return nil }
        guard let cardID = record.object(forKey: "cardID") as? NSNumber,
            let participatedUnit = record["participatedUnit"] as? CKRecord.Reference,
            let skillLevel = record["skillLevel"] as? NSNumber,
            let vocalLevel = record["vocalLevel"] as? NSNumber,
            let danceLevel = record["danceLevel"] as? NSNumber,
            let visualLevel = record["visualLevel"] as? NSNumber,
            let participatedPosition = record["participatedPosition"] as? NSNumber,
            let localCreatedAt = record["localCreatedAt"] as? Date,
            let localModifiedAt = record["localModifiedAt"] as? Date,
            let creatorID = record.creatorUserRecordID?.recordName else {
                return nil
        }
        
        self.id = record.recordID.recordName
        self.creatorID = creatorID
        self.participatedUnit = participatedUnit
        self.localCreatedAt = localCreatedAt
        self.localModifiedAt = localModifiedAt
        self.cardID = cardID.int64Value
        self.skillLevel = skillLevel.int64Value
        self.vocalLevel = vocalLevel.int64Value
        self.danceLevel = danceLevel.int64Value
        self.visualLevel = visualLevel.int64Value
        self.lifeLevel = (record["lifeLevel"] as? NSNumber)?.int64Value ?? 0
        self.skillPotentialLevel = (record["skillPotentialLevel"] as? NSNumber)?.int64Value ?? 0
        self.participatedPosition = participatedPosition.int64Value
    }
}

extension RemoteMember {

    var potential: Potential {
        return Potential(vocal: Int(vocalLevel), dance: Int(danceLevel), visual: Int(visualLevel), skill: Int(skillPotentialLevel), life: Int(lifeLevel))
    }
    
    @discardableResult
    func insert(into context: NSManagedObjectContext) -> Member {
        let member = Member.insert(into: context, cardID: Int(cardID), skillLevel: Int(skillLevel), potential: potential, participatedPostion: Int(participatedPosition))
        member.creatorID = self.creatorID
        member.remoteIdentifier = id
        member.createdAt = self.localCreatedAt
        member.updatedAt = self.localModifiedAt
        return member
    }
    
}
