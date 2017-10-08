//
//  FavoriteSong.swift
//  DereGuide
//
//  Created by zzk on 11/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

public class FavoriteSong: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteChara> {
        return NSFetchRequest<FavoriteChara>(entityName: "FavoriteSong")
    }
    
    @NSManaged public var musicID: Int32
    
    @NSManaged public var createdAt: Date
    
    @NSManaged fileprivate var primitiveCreatedAt: Date
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        primitiveCreatedAt = Date()
    }
    
    @discardableResult
    static func insert(into moc: NSManagedObjectContext, musicID: Int) -> FavoriteSong {
        let favoriteSong: FavoriteSong = moc.insertObject()
        favoriteSong.musicID = Int32(musicID)
        return favoriteSong
    }
    
}

extension FavoriteSong: Managed {
    
    public static var entityName: String {
        return "FavoriteSong"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(FavoriteSong.musicID), ascending: false)]
    }
    
    public static var defaultPredicate: NSPredicate {
        return notMarkedForDeletionPredicate
    }
    
}

extension FavoriteSong: IDSearchable {
    var searchedID: Int {
        return Int(musicID)
    }
}

extension FavoriteSong: DelayedDeletable {
    @NSManaged public var markedForDeletionDate: Date?
}

extension FavoriteSong: RemoteDeletable {
    @NSManaged public var markedForRemoteDeletion: Bool
    @NSManaged public var remoteIdentifier: String?
}

extension FavoriteSong: UserOwnable {
    @NSManaged public var creatorID: String?
}

extension FavoriteSong: RemoteUploadable {
    public func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: RemoteFavoriteSong.recordType)
        record["musicID"] = musicID as CKRecordValue
        record["localCreatedAt"] = createdAt as NSDate
        return record
    }
}


