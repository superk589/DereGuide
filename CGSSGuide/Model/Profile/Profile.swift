//
//  Profile.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/2.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class Profile: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var gameID: String
    @NSManaged public var nickName: String
    @NSManaged public var cuteCardID: Int32
    @NSManaged public var coolCardID: Int32
    @NSManaged public var passionCardID: Int32
    @NSManaged public var cuteVocalLevel: Int16
    @NSManaged public var allTypeCardID: Int32
    @NSManaged public var guestAllTypeCardID: Int32
    @NSManaged public var guestPassionCardID: Int32
    @NSManaged public var guestCoolCardID: Int32
    @NSManaged public var guestCuteCardID: Int32
    @NSManaged public var passionVisualLevel: Int16
    @NSManaged public var passionDanceLevel: Int16
    @NSManaged public var passionVocalLevel: Int16
    @NSManaged public var coolDanceLevel: Int16
    @NSManaged public var coolVocalLevel: Int16
    @NSManaged public var cuteVisualLevel: Int16
    @NSManaged public var cuteDanceLevel: Int16
    @NSManaged public var allTypeVisualLevel: Int16
    @NSManaged public var allTypeDanceLevel: Int16
    @NSManaged public var allTypeVocalLevel: Int16
    @NSManaged public var message: String?
    @NSManaged public var creatorID: String?
    @NSManaged public var remoteIdentifier: String?
    @NSManaged public var coolVisualLevel: Int16

}

extension Profile {
    
    var cutePotential: CGSSPotential {
        return CGSSPotential(vocalLevel: Int(cuteVocalLevel), danceLevel: Int(cuteDanceLevel), visualLevel: Int(cuteVisualLevel), lifeLevel: 0)
    }
    
    var coolPotential: CGSSPotential {
        return CGSSPotential(vocalLevel: Int(coolVocalLevel), danceLevel: Int(coolDanceLevel), visualLevel: Int(coolVisualLevel), lifeLevel: 0)
    }
    
    var passtionPotential: CGSSPotential {
        return CGSSPotential(vocalLevel: Int(passionVocalLevel), danceLevel: Int(passionDanceLevel), visualLevel: Int(passionVisualLevel), lifeLevel: 0)
    }
    
    var allTypePotential: CGSSPotential {
        return CGSSPotential(vocalLevel: Int(allTypeVocalLevel), danceLevel: Int(allTypeDanceLevel), visualLevel: Int(allTypeVisualLevel), lifeLevel: 0)
    }
}

extension Profile: Managed {
    
    public static var entityName: String {
        return "Profile"
    }
    
}

extension Profile: RemoteUploadable {
    
    public func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: RemoteProfile.recordType)
        
        record["gameID"] = gameID as CKRecordValue
        record["nickName"] = nickName as CKRecordValue
        record["cuteCardID"] = cuteCardID as CKRecordValue
        record["coolCardID"] = coolCardID as CKRecordValue
        record["passionCardID"] = passionCardID as CKRecordValue
        record["cuteVocalLevel"] = cuteVocalLevel as CKRecordValue
        record["allTypeCardID"] = allTypeCardID as CKRecordValue
        record["guestAllTypeCardID"] = guestAllTypeCardID as CKRecordValue
        record["guestPassionCardID"] = guestPassionCardID as CKRecordValue
        record["guestCoolCardID"] = guestCoolCardID as CKRecordValue
        record["guestCuteCardID"] = guestCuteCardID as CKRecordValue
        record["passionVisualLevel"] = passionVisualLevel as CKRecordValue
        record["passionDanceLevel"] = passionDanceLevel as CKRecordValue
        record["passionVocalLevel"] = passionVocalLevel as CKRecordValue
        record["coolDanceLevel"] = coolDanceLevel as CKRecordValue
        record["coolVocalLevel"] = coolVocalLevel as CKRecordValue
        record["cuteVisualLevel"] = cuteVisualLevel as CKRecordValue
        record["cuteDanceLevel"] = cuteDanceLevel as CKRecordValue
        record["allTypeVisualLevel"] = allTypeVisualLevel as CKRecordValue
        record["allTypeDanceLevel"] = allTypeDanceLevel as CKRecordValue
        record["allTypeVocalLevel"] = allTypeVocalLevel as CKRecordValue
        record["message"] = (message ?? "") as CKRecordValue
        record["coolVisualLevel"] = coolVisualLevel as CKRecordValue
        
        return record
    }
    
}

extension Profile {
    convenience init(remoteRecord: RemoteProfile, context: NSManagedObjectContext) {

        self.init(entity: Profile.entity, insertInto: context)

        self.gameID = remoteRecord.gameID
        self.nickName = remoteRecord.nickName
        self.cuteCardID = Int32(remoteRecord.cuteCardID)
        self.coolCardID = Int32(remoteRecord.coolCardID)
        self.passionCardID = Int32(remoteRecord.passionCardID)
        self.cuteVocalLevel = Int16(remoteRecord.cuteVocalLevel)
        self.allTypeCardID = Int32(remoteRecord.allTypeCardID)
        self.guestAllTypeCardID = Int32(remoteRecord.guestAllTypeCardID)
        self.guestPassionCardID = Int32(remoteRecord.guestPassionCardID)
        self.guestCoolCardID = Int32(remoteRecord.guestCoolCardID)
        self.guestCuteCardID = Int32(remoteRecord.guestCuteCardID)
        self.passionVisualLevel = Int16(remoteRecord.passionVisualLevel)
        self.passionDanceLevel = Int16(remoteRecord.passionDanceLevel)
        self.passionVocalLevel = Int16(remoteRecord.passionVocalLevel)
        self.coolDanceLevel = Int16(remoteRecord.coolDanceLevel)
        self.coolVocalLevel = Int16(remoteRecord.coolVocalLevel)
        self.cuteVisualLevel = Int16(remoteRecord.cuteVisualLevel)
        self.cuteDanceLevel = Int16(remoteRecord.cuteDanceLevel)
        self.allTypeVisualLevel = Int16(remoteRecord.allTypeVisualLevel)
        self.allTypeDanceLevel = Int16(remoteRecord.allTypeDanceLevel)
        self.allTypeVocalLevel = Int16(remoteRecord.allTypeVocalLevel)
        self.message = remoteRecord.message
        self.remoteIdentifier = remoteRecord.id
        self.creatorID = remoteRecord.creatorID
        self.coolVisualLevel = Int16(remoteRecord.coolVisualLevel)
        
    }
}
