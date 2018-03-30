//
//  DMProfile.swift
//  DereGuide
//
//  Created by zzk on 31/08/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class DMProfile : NSObject, NSCoding{
    
    var albumNo : Int!
    var cleared : DMCleared!
    var comment : String!
    var commuNo : Int!
    var creationTs : Int!
    var emblemExValue : Int!
    var emblemId : Int!
    var fan : Int!
    var fullCombo : DMCleared!
    var id : Int!
    var lastLoginTs : Int!
    var leaderCard : DMLeaderCard!
    var level : Int!
    var name : String!
    var prp : Int!
    var rank : Int!
    var supportCards : DMSupportCard!
    var timestamp : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        albumNo = json["album_no"].intValue
        let clearedJson = json["cleared"]
        if !clearedJson.isEmpty{
            cleared = DMCleared(fromJson: clearedJson)
        }
        comment = json["comment"].stringValue
        commuNo = json["commu_no"].intValue
        creationTs = json["creation_ts"].intValue
        emblemExValue = json["emblem_ex_value"].intValue
        emblemId = json["emblem_id"].intValue
        fan = json["fan"].intValue
        let fullComboJson = json["full_combo"]
        if !fullComboJson.isEmpty{
            fullCombo = DMCleared(fromJson: fullComboJson)
        }
        id = json["id"].intValue
        lastLoginTs = json["last_login_ts"].intValue
        let leaderCardJson = json["leader_card"]
        if !leaderCardJson.isEmpty{
            leaderCard = DMLeaderCard(fromJson: leaderCardJson)
        }
        level = json["level"].intValue
        name = json["name"].stringValue
        prp = json["prp"].intValue
        rank = json["rank"].intValue
        let supportCardsJson = json["support_cards"]
        if !supportCardsJson.isEmpty{
            supportCards = DMSupportCard(fromJson: supportCardsJson)
        }
        timestamp = json["timestamp"].intValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if albumNo != nil{
            dictionary["album_no"] = albumNo
        }
        if cleared != nil{
            dictionary["cleared"] = cleared.toDictionary()
        }
        if comment != nil{
            dictionary["comment"] = comment
        }
        if commuNo != nil{
            dictionary["commu_no"] = commuNo
        }
        if creationTs != nil{
            dictionary["creation_ts"] = creationTs
        }
        if emblemExValue != nil{
            dictionary["emblem_ex_value"] = emblemExValue
        }
        if emblemId != nil{
            dictionary["emblem_id"] = emblemId
        }
        if fan != nil{
            dictionary["fan"] = fan
        }
        if fullCombo != nil{
            dictionary["full_combo"] = fullCombo.toDictionary()
        }
        if id != nil{
            dictionary["id"] = id
        }
        if lastLoginTs != nil{
            dictionary["last_login_ts"] = lastLoginTs
        }
        if leaderCard != nil{
            dictionary["leader_card"] = leaderCard.toDictionary()
        }
        if level != nil{
            dictionary["level"] = level
        }
        if name != nil{
            dictionary["name"] = name
        }
        if prp != nil{
            dictionary["prp"] = prp
        }
        if rank != nil{
            dictionary["rank"] = rank
        }
        if supportCards != nil{
            dictionary["support_cards"] = supportCards.toDictionary()
        }
        if timestamp != nil{
            dictionary["timestamp"] = timestamp
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        albumNo = aDecoder.decodeObject(forKey: "album_no") as? Int
        cleared = aDecoder.decodeObject(forKey: "cleared") as? DMCleared
        comment = aDecoder.decodeObject(forKey: "comment") as? String
        commuNo = aDecoder.decodeObject(forKey: "commu_no") as? Int
        creationTs = aDecoder.decodeObject(forKey: "creation_ts") as? Int
        emblemExValue = aDecoder.decodeObject(forKey: "emblem_ex_value") as? Int
        emblemId = aDecoder.decodeObject(forKey: "emblem_id") as? Int
        fan = aDecoder.decodeObject(forKey: "fan") as? Int
        fullCombo = aDecoder.decodeObject(forKey: "full_combo") as? DMCleared
        id = aDecoder.decodeObject(forKey: "id") as? Int
        lastLoginTs = aDecoder.decodeObject(forKey: "last_login_ts") as? Int
        leaderCard = aDecoder.decodeObject(forKey: "leader_card") as? DMLeaderCard
        level = aDecoder.decodeObject(forKey: "level") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        prp = aDecoder.decodeObject(forKey: "prp") as? Int
        rank = aDecoder.decodeObject(forKey: "rank") as? Int
        supportCards = aDecoder.decodeObject(forKey: "support_cards") as? DMSupportCard
        timestamp = aDecoder.decodeObject(forKey: "timestamp") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if albumNo != nil{
            aCoder.encode(albumNo, forKey: "album_no")
        }
        if cleared != nil{
            aCoder.encode(cleared, forKey: "cleared")
        }
        if comment != nil{
            aCoder.encode(comment, forKey: "comment")
        }
        if commuNo != nil{
            aCoder.encode(commuNo, forKey: "commu_no")
        }
        if creationTs != nil{
            aCoder.encode(creationTs, forKey: "creation_ts")
        }
        if emblemExValue != nil{
            aCoder.encode(emblemExValue, forKey: "emblem_ex_value")
        }
        if emblemId != nil{
            aCoder.encode(emblemId, forKey: "emblem_id")
        }
        if fan != nil{
            aCoder.encode(fan, forKey: "fan")
        }
        if fullCombo != nil{
            aCoder.encode(fullCombo, forKey: "full_combo")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if lastLoginTs != nil{
            aCoder.encode(lastLoginTs, forKey: "last_login_ts")
        }
        if leaderCard != nil{
            aCoder.encode(leaderCard, forKey: "leader_card")
        }
        if level != nil{
            aCoder.encode(level, forKey: "level")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if prp != nil{
            aCoder.encode(prp, forKey: "prp")
        }
        if rank != nil{
            aCoder.encode(rank, forKey: "rank")
        }
        if supportCards != nil{
            aCoder.encode(supportCards, forKey: "support_cards")
        }
        if timestamp != nil{
            aCoder.encode(timestamp, forKey: "timestamp")
        }
        
    }
    
}

extension DMProfile {
    
    var isValid: Bool {
        return String(id).match(pattern: "^[0-9]{9}$").count == 1 && supportCards != nil && leaderCard != nil
    }
}

extension Profile {
    
    static func findOrCreate(in context: NSManagedObjectContext, dmProfile: DMProfile) -> Profile {
        let profile = Profile.findOrCreate(in: context, configure: { _ in })
        profile.gameID = String(dmProfile.id)
        profile.nickName = dmProfile.name
        profile.leaderCardID = Int32(dmProfile.leaderCard.id)
        profile.cuteCardID = Int32(dmProfile.supportCards.cute.id)
        profile.coolCardID = Int32(dmProfile.supportCards.cool.id)
        profile.passionCardID = Int32(dmProfile.supportCards.passion.id)
        profile.cuteVocalLevel = Int16(dmProfile.supportCards.cute.potential.vocal)
        profile.allTypeCardID = Int32(dmProfile.supportCards.all.id)
        profile.passionVisualLevel = Int16(dmProfile.supportCards.passion.potential.visual)
        profile.passionDanceLevel = Int16(dmProfile.supportCards.passion.potential.dance)
        profile.passionVocalLevel = Int16(dmProfile.supportCards.passion.potential.vocal)
        profile.coolDanceLevel = Int16(dmProfile.supportCards.cool.potential.dance)
        profile.coolVocalLevel = Int16(dmProfile.supportCards.cool.potential.vocal)
        profile.cuteVisualLevel = Int16(dmProfile.supportCards.cute.potential.visual)
        profile.cuteDanceLevel = Int16(dmProfile.supportCards.cute.potential.dance)
        profile.allTypeVisualLevel = Int16(dmProfile.supportCards.all.potential.visual)
        profile.allTypeDanceLevel = Int16(dmProfile.supportCards.all.potential.dance)
        profile.allTypeVocalLevel = Int16(dmProfile.supportCards.all.potential.vocal)
        profile.coolVisualLevel = Int16(dmProfile.supportCards.cool.potential.visual)
        profile.cuteLifeLevel = Int16(dmProfile.supportCards.cute.potential.life)
        profile.coolLifeLevel = Int16(dmProfile.supportCards.cool.potential.life)
        profile.passionLifeLevel = Int16(dmProfile.supportCards.passion.potential.life)
        profile.allTypeLifeLevel = Int16(dmProfile.supportCards.all.potential.life)

        return profile
    }
}
