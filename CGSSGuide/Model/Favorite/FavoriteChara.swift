//
//  FavoriteChara.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/26.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

public class FavoriteChara: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteChara> {
        return NSFetchRequest<FavoriteChara>(entityName: "FavoriteChara")
    }
  
    @NSManaged public var charaID: Int32

    @NSManaged public var createdAt: Date
    
    @NSManaged fileprivate var primitiveCreatedAt: Date
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        primitiveCreatedAt = Date()
    }
    
    @discardableResult
    static func insert(into moc: NSManagedObjectContext, charaID: Int) -> FavoriteChara {
        let favoriteChara: FavoriteChara = moc.insertObject()
        favoriteChara.charaID = Int32(charaID)
        return favoriteChara
    }
    
}

extension FavoriteChara: Managed {
    
    public static var entityName: String {
        return "FavoriteChara"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(FavoriteChara.charaID), ascending: false)]
    }
    
    public static var defaultPredicate: NSPredicate {
        return notMarkedForDeletionPredicate
    }
    
}

extension FavoriteChara {}

extension FavoriteChara: DelayedDeletable {
    @NSManaged public var markedForDeletionDate: Date?
}

extension FavoriteChara: RemoteDeletable {
    @NSManaged public var markedForRemoteDeletion: Bool
    @NSManaged public var remoteIdentifier: String?
}

extension FavoriteChara: UserOwnable {
    @NSManaged public var creatorID: String?
}

extension FavoriteChara: RemoteUploadable {
    public func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: RemoteFavoriteChara.recordType)
        record["charaID"] = charaID as CKRecordValue
        record["localCreatedAt"] = createdAt as NSDate
        return record
    }
}

