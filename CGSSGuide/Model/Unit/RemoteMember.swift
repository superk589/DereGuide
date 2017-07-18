//
//  RemoteMember.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/13.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

struct RemoteMember: RemoteRecord {

    var id: String
    var creatorID: String
    var localCreatedAt: Date
    
    var cardID: Int64
    var skillLevel: Int64
    var danceLevel: Int64
    var vocalLevel: Int64
    var visualLevel: Int64
    var participatedPosition: Int64
    var participatedUnit: CKReference
    
}

extension RemoteMember {
    
    static var recordType: String { return "Member" }
    
    init?(record: CKRecord) {
        guard record.recordType == RemoteMember.recordType else { fatalError("wrong record type") }
        guard let cardID = record.object(forKey: "cardID") as? Int64,
            let participatedUnit = record["participatedUnit"] as? CKReference,
            let skillLevel = record["skillLevel"] as? Int64,
            let vocalLevel = record["vocalLevel"] as? Int64,
            let danceLevel = record["danceLevel"] as? Int64,
            let visualLevel = record["visualLevel"] as? Int64,
            let participatedPosition = record["participatedPosition"] as? Int64,
            let localCreatedAt = record["localCreatedAt"] as? Date,
            let creatorID = record.creatorUserRecordID?.recordName else {
                return nil
        }
        
        self.id = record.recordID.recordName
        self.creatorID = creatorID
        self.participatedUnit = participatedUnit
        self.localCreatedAt = localCreatedAt
        self.cardID = cardID
        self.skillLevel = skillLevel
        self.vocalLevel = vocalLevel
        self.danceLevel = danceLevel
        self.visualLevel = visualLevel
        self.participatedPosition = participatedPosition
    }
}

extension RemoteMember {

    var potential: CGSSPotential {
        return CGSSPotential(vocalLevel: Int(vocalLevel), danceLevel: Int(danceLevel), visualLevel: Int(visualLevel), lifeLevel: 0)
    }
    
    @discardableResult
    func insert(into context: NSManagedObjectContext) -> Member {
        let member = Member.insert(into: context, cardID: Int(cardID), skillLevel: Int(skillLevel), potential: potential, participatedPostion: Int(participatedPosition))
        member.creatorID = self.creatorID
        member.remoteIdentifier = id
        return member
    }
    
}
