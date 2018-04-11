//
//  FavoriteCard.swift
//  DereGuide
//
//  Created by zzk on 2017/7/26.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

public class FavoriteCard: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCard> {
        return NSFetchRequest<FavoriteCard>(entityName: "FavoriteCard")
    }
  
    @NSManaged public var cardID: Int32

    @NSManaged public var createdAt: Date
    
    @NSManaged fileprivate var primitiveCreatedAt: Date
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        primitiveCreatedAt = Date()
    }
    
    @discardableResult
    static func insert(into moc: NSManagedObjectContext, cardID: Int) -> FavoriteCard {
        let favoriteCard: FavoriteCard = moc.insertObject()
        favoriteCard.cardID = Int32(cardID)
        return favoriteCard
    }
    
}

extension FavoriteCard: Managed {
    
    public static var entityName: String {
        return "FavoriteCard"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(FavoriteCard.cardID), ascending: false)]
    }
    
    public static var defaultPredicate: NSPredicate {
        return notMarkedForDeletionPredicate
    }
    
}

extension FavoriteCard: IDSearchable {
    var searchedID: Int {
        return Int(cardID)
    }
}

extension FavoriteCard: DelayedDeletable {
    @NSManaged public var markedForDeletionDate: Date?
}

extension FavoriteCard: RemoteDeletable {
    @NSManaged public var markedForRemoteDeletion: Bool
    @NSManaged public var remoteIdentifier: String?
}

extension FavoriteCard: UserOwnable {
    @NSManaged public var creatorID: String?
}

extension FavoriteCard: RemoteUploadable {
    public func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: RemoteFavoriteCard.recordType)
        record["cardID"] = cardID as CKRecordValue
        record["localCreatedAt"] = createdAt as NSDate
        return record
    }
}
