//
//  Member+CoreDataClass.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/7.
//  Copyright © 2017年 zzk. All rights reserved.
//
//

import Foundation
import CoreData
import CloudKit

public class Member: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }
    
    @NSManaged public var cardID: Int32
    @NSManaged public var skillLevel: Int16
    @NSManaged public var vocalLevel: Int16
    @NSManaged public var danceLevel: Int16
    @NSManaged public var visualLevel: Int16
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var participatedUnit: Unit?
    @NSManaged public var participatedPosition: Int16
    
    @NSManaged fileprivate var primitiveCreatedAt: Date
    @NSManaged fileprivate var primitiveUpdatedAt: Date
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        primitiveCreatedAt = Date()
        primitiveUpdatedAt = Date()
    }
    
    public override func willSave() {
        super.willSave()
        if hasChanges {
            if let context = managedObjectContext {
                // modification made by main queue will upload to the remote
                if context.concurrencyType == .mainQueueConcurrencyType {
                    refreshUpdateDate()
                    if hasLocalTrackedChanges && !isInserted {
                        markForRemoteModification()
                    }                    
                }
            }
            if hasLocalTrackedChanges {
                // when members change, let the unit they participated in know the change and refresh ui
                participatedUnit?.refreshUpdateDate()
            }
        }
        
        // if a member has no participated unit, delete it
        if participatedUnit == nil {
            markForLocalDeletion()
        }
    }
    
    func setBy(cardID: Int, skillLevel: Int, potential: CGSSPotential) {
        self.cardID = Int32(cardID)
        self.skillLevel = Int16(skillLevel)
        self.vocalLevel = Int16(potential.vocalLevel)
        self.danceLevel = Int16(potential.danceLevel)
        self.visualLevel = Int16(potential.visualLevel)
    }
    
    @discardableResult
    private static func insert(into moc: NSManagedObjectContext, cardID: Int32, skillLevel: Int16, potential: CGSSPotential, participatedPostion: Int16 = 0) -> Member {
        let member: Member = moc.insertObject()
        member.cardID = cardID
        member.skillLevel = skillLevel
        member.vocalLevel = Int16(potential.vocalLevel)
        member.danceLevel = Int16(potential.danceLevel)
        member.visualLevel = Int16(potential.visualLevel)
        member.participatedPosition = participatedPostion
        return member
    }
    
    @discardableResult
    static func insert(into moc: NSManagedObjectContext, cardID: Int, skillLevel: Int, potential: CGSSPotential, participatedPostion: Int = 0) -> Member {
        return insert(into: moc, cardID: Int32(cardID), skillLevel: Int16(skillLevel), potential: potential, participatedPostion: Int16(participatedPostion))
    }
    
    @discardableResult
    static func insert(into moc: NSManagedObjectContext, anotherMember: Member) -> Member {
        return insert(into: moc, cardID: anotherMember.cardID, skillLevel: anotherMember.skillLevel, potential: anotherMember.potential, participatedPostion: anotherMember.participatedPosition)
    }
    
}

extension Member: UpdateTimestampable {}

extension Member: RemoteRefreshable {
    @NSManaged public var markedForLocalChange: Bool
    var localTrackedKeys: [String] {
        return ["cardID", "vocalLevel", "skillLevel", "danceLevel", "visualLevel"]
    }
}

extension Member: RemoteUpdatable {
    
    typealias R = RemoteMember
    
    func update(using remoteRecord: RemoteMember) {
        guard remoteRecord.localModifiedAt >= self.updatedAt else {
            print("no need to update this member \(self.remoteIdentifier!)")
            markForRemoteModification()
            return
        }
        self.cardID = Int32(remoteRecord.cardID)
        self.vocalLevel = Int16(remoteRecord.vocalLevel)
        self.danceLevel = Int16(remoteRecord.danceLevel)
        self.visualLevel = Int16(remoteRecord.visualLevel)
        self.skillLevel = Int16(remoteRecord.skillLevel)
        self.updatedAt = remoteRecord.localModifiedAt
    }
    
}

extension Member {
    
    var card: CGSSCard? {
        let dao = CGSSDAO.shared
        return dao.findCardById(Int(cardID))
    }
    
    var potential: CGSSPotential {
        return CGSSPotential(vocalLevel: Int(vocalLevel), danceLevel: Int(danceLevel), visualLevel: Int(visualLevel), lifeLevel: 0)
    }
    
}

extension Member: Managed {
    
    public static var entityName: String {
        return "Member"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(updatedAt), ascending: false)]
    }
    
    public static var defaultPredicate: NSPredicate {
        return notMarkedForDeletionPredicate
    }
    
}

extension Member: DelayedDeletable {
    @NSManaged public var markedForDeletionDate: Date?
}

extension Member: RemoteDeletable {
    @NSManaged public var markedForRemoteDeletion: Bool
    @NSManaged public var remoteIdentifier: String?
}

extension Member: UserOwnable {
    @NSManaged public var creatorID: String?
}

extension Member: RemoteUploadable {
    
    public func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: RemoteMember.recordType)
        record["cardID"] = cardID as CKRecordValue
        record["skillLevel"] = skillLevel as CKRecordValue
        record["vocalLevel"] = vocalLevel as CKRecordValue
        record["danceLevel"] = danceLevel as CKRecordValue
        record["visualLevel"] = visualLevel as CKRecordValue
        record["participatedPosition"] = participatedPosition as CKRecordValue
        record["participatedUnit"] = participatedUnit!.ckReference!
        record["localCreatedAt"] = createdAt as NSDate
        record["localModifiedAt"] = updatedAt as NSDate
        return record
    }

}


extension Member {
    static func ==(lhs: Member, rhs: Member) -> Bool {
        if let lCard = lhs.card, let rCard = rhs.card {
            if lCard.id == rCard.id && lhs.potential == rhs.potential && lhs.skillLevel == rhs.skillLevel {
                return true
            }
        }
        return false
    }
}

