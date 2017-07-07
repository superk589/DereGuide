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

public class Member: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }
    
    @NSManaged public var creatorId: String?
    @NSManaged public var cardId: Int32
    @NSManaged public var skillLevel: Int16
    @NSManaged public var vocalLevel: Int16
    @NSManaged public var danceLevel: Int16
    @NSManaged public var visualLevel: Int16
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var remoteIdentifier: String?
    @NSManaged public var units: Set<Unit>
    
    @NSManaged fileprivate var primitiveCreatedAt: Date
    @NSManaged fileprivate var primitiveUpdatedAt: Date
    
    var card: CGSSCard? {
        let dao = CGSSDAO.shared
        return dao.findCardById(Int(cardId))
    }
    
    var potential: CGSSPotential {
        return CGSSPotential(vocalLevel: Int(vocalLevel), danceLevel: Int(danceLevel), visualLevel: Int(visualLevel), lifeLevel: 0)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        primitiveCreatedAt = Date()
        primitiveUpdatedAt = Date()
    }
    
    static func insert(into moc: NSManagedObjectContext, cardId: Int, skillLevel: Int, potential: CGSSPotential) -> Member {
        let member: Member = moc.insertObject()
        member.cardId = Int32(cardId)
        member.skillLevel = Int16(skillLevel)
        member.vocalLevel = Int16(potential.vocalLevel)
        member.danceLevel = Int16(potential.danceLevel)
        member.visualLevel = Int16(potential.visualLevel)
        return member
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
}
