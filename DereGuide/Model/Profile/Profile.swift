//
//  Profile.swift
//  DereGuide
//
//  Created by zzk on 2017/8/2.
//  Copyright © 2017 zzk. All rights reserved.
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
    @NSManaged public var allTypeLifeLevel: Int16
    @NSManaged public var cuteLifeLevel: Int16
    @NSManaged public var coolLifeLevel: Int16
    @NSManaged public var passionLifeLevel: Int16
    
    @NSManaged public var allTypeSkillPotentialLevel: Int16
    @NSManaged public var cuteSkillPotentialLevel: Int16
    @NSManaged public var coolSkillPotentialLevel: Int16
    @NSManaged public var passionSkillPotentialLevel: Int16
    
    @NSManaged public var guestCuteMinLevel: Int16
    @NSManaged public var guestCoolMinLevel: Int16
    @NSManaged public var guestPassionMinLevel: Int16
    @NSManaged public var guestAllTypeMinLevel: Int16
    @NSManaged public var isOpen: Bool
    
    @NSManaged public var remoteCreatedAt: Date?
    
    @NSManaged public var leaderCardID: Int32
    
    @NSManaged public var freeCharaID1: Int32
    @NSManaged public var freeCharaID2: Int32
    @NSManaged public var freeCharaID3: Int32
    @NSManaged public var freeCharaID4: Int32
    @NSManaged public var freeCharaID5: Int32

    override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue("", forKey: "gameID")
        setPrimitiveValue("", forKey: "nickName")
    }
}

extension Profile {
    
    var cutePotential: Potential {
        get {
            return Potential(vocal: Int(cuteVocalLevel), dance: Int(cuteDanceLevel), visual: Int(cuteVisualLevel), skill: Int(cuteSkillPotentialLevel), life: Int(cuteLifeLevel))
        }
        set {
            cuteVocalLevel = Int16(newValue.vocal)
            cuteDanceLevel = Int16(newValue.dance)
            cuteVisualLevel = Int16(newValue.visual)
            cuteLifeLevel = Int16(newValue.life)
            cuteSkillPotentialLevel = Int16(newValue.skill)
        }
    }
    
    var coolPotential: Potential {
        get {
            return Potential(vocal: Int(coolVocalLevel), dance: Int(coolDanceLevel), visual: Int(coolVisualLevel), skill: Int(coolSkillPotentialLevel), life: Int(coolLifeLevel))
        }
        set {
            coolVocalLevel = Int16(newValue.vocal)
            coolDanceLevel = Int16(newValue.dance)
            coolVisualLevel = Int16(newValue.visual)
            coolLifeLevel = Int16(newValue.life)
            coolSkillPotentialLevel = Int16(newValue.skill)
        }
    }
    
    var passionPotential: Potential {
        get {
            return Potential(vocal: Int(passionVocalLevel), dance: Int(passionDanceLevel), visual: Int(passionVisualLevel), skill: Int(passionSkillPotentialLevel), life: Int(passionLifeLevel))
        }
        set {
            passionVocalLevel = Int16(newValue.vocal)
            passionDanceLevel = Int16(newValue.dance)
            passionVisualLevel = Int16(newValue.visual)
            passionLifeLevel = Int16(newValue.life)
            passionSkillPotentialLevel = Int16(newValue.skill)
        }
    }
    
    var allTypePotential: Potential {
        get {
            return Potential(vocal: Int(allTypeVocalLevel), dance: Int(allTypeDanceLevel), visual: Int(allTypeVisualLevel), skill: Int(allTypeSkillPotentialLevel), life: Int(allTypeLifeLevel))
        }
        set {
            allTypeVocalLevel = Int16(newValue.vocal)
            allTypeDanceLevel = Int16(newValue.dance)
            allTypeVisualLevel = Int16(newValue.visual)
            allTypeLifeLevel = Int16(newValue.life)
            allTypeSkillPotentialLevel = Int16(newValue.skill)
        }
    }
    
    var myCenters: [(Int, Potential)] {
        set {
            cuteCardID = Int32(newValue[0].0)
            cutePotential = newValue[0].1
            coolCardID = Int32(newValue[1].0)
            coolPotential = newValue[1].1
            passionCardID = Int32(newValue[2].0)
            passionPotential = newValue[2].1
            allTypeCardID = Int32(newValue[3].0)
            allTypePotential = newValue[3].1
        }
        get {
            return [(Int(cuteCardID), cutePotential),
             (Int(coolCardID), coolPotential),
             (Int(passionCardID), passionPotential),
             (Int(allTypeCardID), allTypePotential)]
        }
    }
    
    var centersWanted: [(Int, Int)] {
        set {
            guestCuteCardID = Int32(newValue[0].0)
            guestCuteMinLevel = Int16(newValue[0].1)
            guestCoolCardID = Int32(newValue[1].0)
            guestCoolMinLevel = Int16(newValue[1].1)
            guestPassionCardID = Int32(newValue[2].0)
            guestPassionMinLevel = Int16(newValue[2].1)
            guestAllTypeCardID = Int32(newValue[3].0)
            guestAllTypeMinLevel = Int16(newValue[3].1)
        }
        get {
            return [(Int(guestCuteCardID), Int(guestCuteMinLevel)),
                    (Int(guestCoolCardID), Int(guestCoolMinLevel)),
                    (Int(guestPassionCardID), Int(guestPassionMinLevel)),
                    (Int(guestAllTypeCardID), Int(guestAllTypeMinLevel))]
        }
    }
    
    
    func reset() {
        self.gameID = ""
        self.nickName = ""
        self.cuteCardID = 0
        self.coolCardID = 0
        self.passionCardID = 0
        self.cuteVocalLevel = 0
        self.allTypeCardID = 0
        self.guestAllTypeCardID = 0
        self.guestPassionCardID = 0
        self.guestCoolCardID = 0
        self.guestCuteCardID = 0
        self.passionVisualLevel = 0
        self.passionDanceLevel = 0
        self.passionVocalLevel = 0
        self.coolDanceLevel = 0
        self.coolVocalLevel = 0
        self.cuteVisualLevel = 0
        self.cuteDanceLevel = 0
        self.allTypeVisualLevel = 0
        self.allTypeDanceLevel = 0
        self.allTypeVocalLevel = 0
        self.message = ""
        self.coolVisualLevel = 0
        self.passionLifeLevel = 0
        self.cuteLifeLevel = 0
        self.coolLifeLevel = 0
        self.allTypeLifeLevel = 0
        
        self.passionSkillPotentialLevel = 0
        self.cuteSkillPotentialLevel = 0
        self.coolSkillPotentialLevel = 0
        self.allTypeSkillPotentialLevel = 0
        
        self.guestCuteMinLevel = 0
        self.guestCoolMinLevel = 0
        self.guestPassionMinLevel = 0
        self.guestAllTypeMinLevel = 0
        
        self.leaderCardID = 0
        
        self.freeCharaID1 = 0
        self.freeCharaID2 = 0
        self.freeCharaID3 = 0
        self.freeCharaID4 = 0
        self.freeCharaID5 = 0
    }
}

extension Profile: Managed {
    
    public static var entityName: String {
        return "Profile"
    }
    
}

// not really need to be remote deletable
extension Profile: RemoteDeletable {
    var markedForRemoteDeletion: Bool {
        get {
            return false
        }
        set {
            // no-op
        }
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
        
        record["guestCuteMinLevel"] = guestCuteMinLevel as CKRecordValue
        record["guestCoolMinLevel"] = guestCoolMinLevel as CKRecordValue
        record["guestPassionMinLevel"] = guestPassionMinLevel as CKRecordValue
        record["guestAllTypeMinLevel"] = guestAllTypeMinLevel as CKRecordValue
        record["isOpen"] = (isOpen ? 1 : 0) as CKRecordValue
        
        record["cuteTotalLevel"] = cutePotential.totalLevel as CKRecordValue
        record["coolTotalLevel"] = coolPotential.totalLevel as CKRecordValue
        record["passionTotalLevel"] = passionPotential.totalLevel as CKRecordValue
        record["allTypeTotalLevel"] = allTypePotential.totalLevel as CKRecordValue
        record["leaderCardID"] = leaderCardID as CKRecordValue
        
        record["allTypeLifeLevel"] = allTypeLifeLevel as CKRecordValue
        record["cuteLifeLevel"] = cuteLifeLevel as CKRecordValue
        record["coolLifeLevel"] = coolLifeLevel as CKRecordValue
        record["passionLifeLevel"] = passionLifeLevel as CKRecordValue
        
        record["allTypeSkillPotentialLevel"] = allTypeSkillPotentialLevel as CKRecordValue
        record["cuteSkillPotentialLevel"] = cuteSkillPotentialLevel as CKRecordValue
        record["coolSkillPotentialLevel"] = coolSkillPotentialLevel as CKRecordValue
        record["passionSkillPotentialLevel"] = passionSkillPotentialLevel as CKRecordValue
        
        record["freeCharaID1"] = freeCharaID1 as CKRecordValue
        record["freeCharaID2"] = freeCharaID2 as CKRecordValue
        record["freeCharaID3"] = freeCharaID3 as CKRecordValue
        record["freeCharaID4"] = freeCharaID4 as CKRecordValue
        record["freeCharaID5"] = freeCharaID5 as CKRecordValue

        return record
    }
    
}

extension Profile {
    
    static func insert(remoteRecord: RemoteProfile, into context: NSManagedObjectContext) -> Profile {

        let profile: Profile = context.insertObject()
        profile.gameID = remoteRecord.gameID
        profile.nickName = remoteRecord.nickName
        profile.cuteCardID = Int32(remoteRecord.cuteCardID)
        profile.coolCardID = Int32(remoteRecord.coolCardID)
        profile.passionCardID = Int32(remoteRecord.passionCardID)
        profile.cuteVocalLevel = Int16(remoteRecord.cuteVocalLevel)
        profile.allTypeCardID = Int32(remoteRecord.allTypeCardID)
        profile.guestAllTypeCardID = Int32(remoteRecord.guestAllTypeCardID)
        profile.guestPassionCardID = Int32(remoteRecord.guestPassionCardID)
        profile.guestCoolCardID = Int32(remoteRecord.guestCoolCardID)
        profile.guestCuteCardID = Int32(remoteRecord.guestCuteCardID)
        profile.passionVisualLevel = Int16(remoteRecord.passionVisualLevel)
        profile.passionDanceLevel = Int16(remoteRecord.passionDanceLevel)
        profile.passionVocalLevel = Int16(remoteRecord.passionVocalLevel)
        profile.coolDanceLevel = Int16(remoteRecord.coolDanceLevel)
        profile.coolVocalLevel = Int16(remoteRecord.coolVocalLevel)
        profile.cuteVisualLevel = Int16(remoteRecord.cuteVisualLevel)
        profile.cuteDanceLevel = Int16(remoteRecord.cuteDanceLevel)
        profile.allTypeVisualLevel = Int16(remoteRecord.allTypeVisualLevel)
        profile.allTypeDanceLevel = Int16(remoteRecord.allTypeDanceLevel)
        profile.allTypeVocalLevel = Int16(remoteRecord.allTypeVocalLevel)
        profile.message = remoteRecord.message
        profile.remoteIdentifier = remoteRecord.id
        profile.creatorID = remoteRecord.creatorID
        profile.coolVisualLevel = Int16(remoteRecord.coolVisualLevel)
        
        profile.guestCuteMinLevel = Int16(remoteRecord.guestCuteMinLevel)
        profile.guestCoolMinLevel = Int16(remoteRecord.guestCoolMinLevel)
        profile.guestPassionMinLevel = Int16(remoteRecord.guestPassionMinLevel)
        profile.guestAllTypeMinLevel = Int16(remoteRecord.guestAllTypeMinLevel)
        profile.isOpen = remoteRecord.isOpen == 1
        
        profile.remoteCreatedAt = remoteRecord.remoteModifiedAt
        profile.leaderCardID = Int32(remoteRecord.leaderCardID)
        
        profile.passionLifeLevel = Int16(remoteRecord.passionLifeLevel)
        profile.cuteLifeLevel = Int16(remoteRecord.cuteLifeLevel)
        profile.coolLifeLevel = Int16(remoteRecord.coolLifeLevel)
        profile.allTypeLifeLevel = Int16(remoteRecord.allTypeLifeLevel)
        
        profile.passionSkillPotentialLevel = Int16(remoteRecord.passionSkillPotentialLevel)
        profile.cuteSkillPotentialLevel = Int16(remoteRecord.cuteSkillPotentialLevel)
        profile.coolSkillPotentialLevel = Int16(remoteRecord.coolSkillPotentialLevel)
        profile.allTypeSkillPotentialLevel = Int16(remoteRecord.allTypeSkillPotentialLevel)
        
        profile.freeCharaID1 = Int32(remoteRecord.freeCharaID1)
        profile.freeCharaID2 = Int32(remoteRecord.freeCharaID2)
        profile.freeCharaID3 = Int32(remoteRecord.freeCharaID3)
        profile.freeCharaID4 = Int32(remoteRecord.freeCharaID4)
        profile.freeCharaID5 = Int32(remoteRecord.freeCharaID5)
        
        return profile
        
    }
}
