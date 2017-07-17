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
    @NSManaged public var centeredUnit: Unit?
    @NSManaged public var guestedUnit: Unit?
    
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
            refreshUpdateDate()
            unit?.refreshUpdateDate()
            markForRemoteModification()
            unit?.markForRemoteModification()
        }
        if unit == nil {
            markForLocalDeletion()
        }
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

extension Member: RemoteModifiable {
    @NSManaged public var markedForLocalChange: Bool
}

extension Member {
    
    var unit: Unit! {
        return participatedUnit ?? centeredUnit ?? guestedUnit
    }
    
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
        record["skillLevel"] = skillLevel as CKRecordValue
        record["vocalLevel"] = vocalLevel as CKRecordValue
        record["danceLevel"] = danceLevel as CKRecordValue
        record["visualLevel"] = visualLevel as CKRecordValue
        record["participatedPosition"] = participatedPosition as CKRecordValue
        record["participatedUnit"] = CKReference(record: unit.toCKRecord(), action: .deleteSelf)
        record["localCreatedAt"] = createdAt as CKRecordValue
        record["localModifiedAt"] = updatedAt as CKRecordValue
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

