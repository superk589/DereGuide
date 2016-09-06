//
//  CGSSCard.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

extension CGSSCard {
    
    var attShort: String! {
        switch attribute {
        case "cute":
            return "Cu"
        case "cool":
            return "Co"
        case "passion":
            return "Pa"
        default:
            return "unknown"
        }
    }
    var attColor: UIColor {
        switch attribute {
        case "cute":
            return CGSSGlobal.cuteColor
        case "cool":
            return CGSSGlobal.coolColor
        case "passion":
            return CGSSGlobal.passionColor
        default:
            return CGSSGlobal.allTypeColor
        }
    }
    
    var chara: CGSSChar? {
        if let id = charaId {
            return CGSSDAO.sharedDAO.findCharById(id)
        }
        return nil
    }
    var leaderSkill: CGSSLeaderSkill? {
        if let id = leaderSkillId {
            return CGSSDAO.sharedDAO.findLeaderSkillById(id)
        }
        return nil
    }
    var skill: CGSSSkill? {
        if let id = skillId {
            return CGSSDAO.sharedDAO.findSkillById(id)
        }
        return nil
    }
    
    // 对卡片进行按更新时间先后排序时使用, 对于新卡取更新时间, 对于旧卡取id%1000
    dynamic var update_id: Int {
        var returnValue = id! % 1000
        if let date = updateTime {
            returnValue += Int(date.timeIntervalSince1970)
        }
        return returnValue
    }
    
    // 用户排序的动态属性
    dynamic var sAlbumId: Int {
        return albumId
    }
    
    dynamic var sRarity: Int {
        return rarity.rarity
    }
    
    //
    dynamic var dance: Int {
        if let base = danceMax, bonus = bonusDance {
            return base + bonus
        }
        return 0
    }
    
    dynamic var vocal: Int {
        if let base = vocalMax, bonus = bonusVocal {
            return base + bonus
        }
        return 0
    }
    dynamic var visual: Int {
        if let base = visualMax, bonus = bonusVisual {
            return base + bonus
        }
        return 0
    }
    dynamic var life: Int {
        if let base = hpMax, bonus = bonusHp {
            return base + bonus
        }
        return 0
    }
    
    dynamic var overall: Int {
        if let base = overallMax, bonus = overallBonus {
            return base + bonus
        }
        return 0
    }
    
    // 用于filter的部分属性
    var rarityFilterType: CGSSCardRarityFilterType {
        return CGSSCardRarityFilterType.init(rarity: rarity.rarity - 1) ?? CGSSCardRarityFilterType.N
    }
    var cardFilterType: CGSSCardFilterType {
        return CGSSCardFilterType.init(typeString: attribute)!
    }
    var attributeFilterType: CGSSAttributeFilterType {
        if let da = danceMax, let vo = vocalMax, let vi = visualMax {
            if da >= vo && da >= vi {
                return CGSSAttributeFilterType.Dance
            } else if vo >= vi && vo >= da {
                return CGSSAttributeFilterType.Vocal
            } else {
                return CGSSAttributeFilterType.Visual
            }
        }
        return CGSSAttributeFilterType.None
    }
    var favoriteFilterType: CGSSFavoriteFilterType {
        return CGSSFavoriteManager.defaultManager.containsCard(self.id!) ? CGSSFavoriteFilterType.InFavorite : CGSSFavoriteFilterType.NotInFavorite
    }
    
}

class CGSSCard: CGSSBaseModel {
    
    var albumId: Int!
    var attribute: String!
    var bestStat: Int!
    var bonusDance: Int!
    var bonusHp: Int!
    var bonusVisual: Int!
    var bonusVocal: Int!
    var cardImageRef: String!
    var charaId: Int!
    var danceMax: Int!
    var danceMin: Int!
    var evolutionId: Int!
    var evolutionType: Int!
    var growType: Int!
    var hasSign: Bool!
    var hasSpread: Bool!
    var hpMax: Int!
    var hpMin: Int!
    var iconImageRef: String!
    var id: Int!
    var leaderSkillId: Int!
    var name: String!
    var nameOnly: String!
    var openDressId: Int!
    var openStoryId: Int!
    var overallBonus: Int!
    var overallMax: Int!
    var overallMin: Int!
    var place: Int!
    var pose: Int!
    var rarity: CGSSCardRarity!
    var seriesId: Int!
    var skillId: Int!
    var soloLive: Int!
    var spreadImageRef: String!
    var spriteImageRef: String!
    var starLessonType: Int!
    var title: String!
    var titleFlag: Int!
    var valist: [AnyObject]!
    var visualMax: Int!
    var visualMin: Int!
    var vocalMax: Int!
    var vocalMin: Int!
    
    /**
         * Instantiate the instance using the passed json values to set the properties values
         */
    init(fromJson json: JSON!) {
        super.init()
        if json == nil {
            return
        }
        albumId = json["album_id"].intValue
        attribute = json["attribute"].stringValue
        bestStat = json["best_stat"].intValue
        bonusDance = json["bonus_dance"].intValue
        bonusHp = json["bonus_hp"].intValue
        bonusVisual = json["bonus_visual"].intValue
        bonusVocal = json["bonus_vocal"].intValue
        cardImageRef = json["card_image_ref"].stringValue
        charaId = json["chara_id"].intValue
        danceMax = json["dance_max"].intValue
        danceMin = json["dance_min"].intValue
        evolutionId = json["evolution_id"].intValue
        evolutionType = json["evolution_type"].intValue
        growType = json["grow_type"].intValue
        hasSign = json["has_sign"].boolValue
        hasSpread = json["has_spread"].boolValue
        hpMax = json["hp_max"].intValue
        hpMin = json["hp_min"].intValue
        iconImageRef = json["icon_image_ref"].stringValue
        id = json["id"].intValue
        leaderSkillId = json["leader_skill_id"].intValue
        name = json["name"].stringValue
        nameOnly = json["name_only"].stringValue
        openDressId = json["open_dress_id"].intValue
        openStoryId = json["open_story_id"].intValue
        overallBonus = json["overall_bonus"].intValue
        overallMax = json["overall_max"].intValue
        overallMin = json["overall_min"].intValue
        place = json["place"].intValue
        pose = json["pose"].intValue
        let rarityJson = json["rarity"]
        if rarityJson != JSON.null {
            rarity = CGSSCardRarity(fromJson: rarityJson)
        }
        seriesId = json["series_id"].intValue
        skillId = json["skill_id"].intValue
        soloLive = json["solo_live"].intValue
        spreadImageRef = json["spread_image_ref"].stringValue
        spriteImageRef = json["sprite_image_ref"].stringValue
        starLessonType = json["star_lesson_type"].intValue
        title = json["title"].stringValue
        titleFlag = json["title_flag"].intValue
        valist = [AnyObject]()
        let valistArray = json["valist"].arrayValue
        for valistJson in valistArray {
            valist.append(valistJson.stringValue)
        }
        visualMax = json["visual_max"].intValue
        visualMin = json["visual_min"].intValue
        vocalMax = json["vocal_max"].intValue
        vocalMin = json["vocal_min"].intValue
        
        let dao = CGSSDAO.sharedDAO
        let skillJson = json["skill"]
        if skillJson != JSON.null && dao.findSkillById(skillId) == nil {
            let skill = CGSSSkill(fromJson: skillJson)
            dao.skillDict.setValue(skill, forKey: String(skillId))
        }
        let charaJson = json["chara"]
        if charaJson != JSON.null && dao.findCharById(charaId) == nil {
            let chara = CGSSChar(fromJson: charaJson)
            dao.charDict.setValue(chara, forKey: String(charaId))
        }
        let leadSkillJson = json["lead_skill"]
        if leadSkillJson != JSON.null && dao.findLeaderSkillById(leaderSkillId) == nil {
            let leadSkill = CGSSLeaderSkill(fromJson: leadSkillJson)
            dao.leaderSkillDict.setValue(leadSkill, forKey: String(leaderSkillId))
        }
        
    }
    
    /**
         * NSCoding required initializer.
         * Fills the data from the passed decoder
         */
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        albumId = aDecoder.decodeObjectForKey("album_id") as? Int
        attribute = aDecoder.decodeObjectForKey("attribute") as? String
        bestStat = aDecoder.decodeObjectForKey("best_stat") as? Int
        bonusDance = aDecoder.decodeObjectForKey("bonus_dance") as? Int
        bonusHp = aDecoder.decodeObjectForKey("bonus_hp") as? Int
        bonusVisual = aDecoder.decodeObjectForKey("bonus_visual") as? Int
        bonusVocal = aDecoder.decodeObjectForKey("bonus_vocal") as? Int
        cardImageRef = aDecoder.decodeObjectForKey("card_image_ref") as? String
        charaId = aDecoder.decodeObjectForKey("chara_id") as? Int
        danceMax = aDecoder.decodeObjectForKey("dance_max") as? Int
        danceMin = aDecoder.decodeObjectForKey("dance_min") as? Int
        evolutionId = aDecoder.decodeObjectForKey("evolution_id") as? Int
        evolutionType = aDecoder.decodeObjectForKey("evolution_type") as? Int
        growType = aDecoder.decodeObjectForKey("grow_type") as? Int
        hasSign = aDecoder.decodeObjectForKey("has_sign") as? Bool
        hasSpread = aDecoder.decodeObjectForKey("has_spread") as? Bool
        hpMax = aDecoder.decodeObjectForKey("hp_max") as? Int
        hpMin = aDecoder.decodeObjectForKey("hp_min") as? Int
        iconImageRef = aDecoder.decodeObjectForKey("icon_image_ref") as? String
        id = aDecoder.decodeObjectForKey("id") as? Int
        leaderSkillId = aDecoder.decodeObjectForKey("leader_skill_id") as? Int
        name = aDecoder.decodeObjectForKey("name") as? String
        nameOnly = aDecoder.decodeObjectForKey("name_only") as? String
        openDressId = aDecoder.decodeObjectForKey("open_dress_id") as? Int
        openStoryId = aDecoder.decodeObjectForKey("open_story_id") as? Int
        overallBonus = aDecoder.decodeObjectForKey("overall_bonus") as? Int
        overallMax = aDecoder.decodeObjectForKey("overall_max") as? Int
        overallMin = aDecoder.decodeObjectForKey("overall_min") as? Int
        place = aDecoder.decodeObjectForKey("place") as? Int
        pose = aDecoder.decodeObjectForKey("pose") as? Int
        rarity = aDecoder.decodeObjectForKey("rarity") as? CGSSCardRarity
        seriesId = aDecoder.decodeObjectForKey("series_id") as? Int
        skillId = aDecoder.decodeObjectForKey("skill_id") as? Int
        soloLive = aDecoder.decodeObjectForKey("solo_live") as? Int
        spreadImageRef = aDecoder.decodeObjectForKey("spread_image_ref") as? String
        spriteImageRef = aDecoder.decodeObjectForKey("sprite_image_ref") as? String
        starLessonType = aDecoder.decodeObjectForKey("star_lesson_type") as? Int
        title = aDecoder.decodeObjectForKey("title") as? String
        titleFlag = aDecoder.decodeObjectForKey("title_flag") as? Int
        valist = aDecoder.decodeObjectForKey("valist") as? [AnyObject]
        visualMax = aDecoder.decodeObjectForKey("visual_max") as? Int
        visualMin = aDecoder.decodeObjectForKey("visual_min") as? Int
        vocalMax = aDecoder.decodeObjectForKey("vocal_max") as? Int
        vocalMin = aDecoder.decodeObjectForKey("vocal_min") as? Int
        
    }
    
    /**
         * NSCoding required method.
         * Encodes mode properties into the decoder
         */
    override func encodeWithCoder(aCoder: NSCoder)
    {
        super.encodeWithCoder(aCoder)
        if albumId != nil {
            aCoder.encodeObject(albumId, forKey: "album_id")
        }
        if attribute != nil {
            aCoder.encodeObject(attribute, forKey: "attribute")
        }
        if bestStat != nil {
            aCoder.encodeObject(bestStat, forKey: "best_stat")
        }
        if bonusDance != nil {
            aCoder.encodeObject(bonusDance, forKey: "bonus_dance")
        }
        if bonusHp != nil {
            aCoder.encodeObject(bonusHp, forKey: "bonus_hp")
        }
        if bonusVisual != nil {
            aCoder.encodeObject(bonusVisual, forKey: "bonus_visual")
        }
        if bonusVocal != nil {
            aCoder.encodeObject(bonusVocal, forKey: "bonus_vocal")
        }
        if cardImageRef != nil {
            aCoder.encodeObject(cardImageRef, forKey: "card_image_ref")
        }
        if charaId != nil {
            aCoder.encodeObject(charaId, forKey: "chara_id")
        }
        if danceMax != nil {
            aCoder.encodeObject(danceMax, forKey: "dance_max")
        }
        if danceMin != nil {
            aCoder.encodeObject(danceMin, forKey: "dance_min")
        }
        if evolutionId != nil {
            aCoder.encodeObject(evolutionId, forKey: "evolution_id")
        }
        if evolutionType != nil {
            aCoder.encodeObject(evolutionType, forKey: "evolution_type")
        }
        if growType != nil {
            aCoder.encodeObject(growType, forKey: "grow_type")
        }
        if hasSign != nil {
            aCoder.encodeObject(hasSign, forKey: "has_sign")
        }
        if hasSpread != nil {
            aCoder.encodeObject(hasSpread, forKey: "has_spread")
        }
        if hpMax != nil {
            aCoder.encodeObject(hpMax, forKey: "hp_max")
        }
        if hpMin != nil {
            aCoder.encodeObject(hpMin, forKey: "hp_min")
        }
        if iconImageRef != nil {
            aCoder.encodeObject(iconImageRef, forKey: "icon_image_ref")
        }
        if id != nil {
            aCoder.encodeObject(id, forKey: "id")
        }
        if leaderSkillId != nil {
            aCoder.encodeObject(leaderSkillId, forKey: "leader_skill_id")
        }
        if name != nil {
            aCoder.encodeObject(name, forKey: "name")
        }
        if nameOnly != nil {
            aCoder.encodeObject(nameOnly, forKey: "name_only")
        }
        if openDressId != nil {
            aCoder.encodeObject(openDressId, forKey: "open_dress_id")
        }
        if openStoryId != nil {
            aCoder.encodeObject(openStoryId, forKey: "open_story_id")
        }
        if overallBonus != nil {
            aCoder.encodeObject(overallBonus, forKey: "overall_bonus")
        }
        if overallMax != nil {
            aCoder.encodeObject(overallMax, forKey: "overall_max")
        }
        if overallMin != nil {
            aCoder.encodeObject(overallMin, forKey: "overall_min")
        }
        if place != nil {
            aCoder.encodeObject(place, forKey: "place")
        }
        if pose != nil {
            aCoder.encodeObject(pose, forKey: "pose")
        }
        if rarity != nil {
            aCoder.encodeObject(rarity, forKey: "rarity")
        }
        if seriesId != nil {
            aCoder.encodeObject(seriesId, forKey: "series_id")
        }
        if skillId != nil {
            aCoder.encodeObject(skillId, forKey: "skill_id")
        }
        if soloLive != nil {
            aCoder.encodeObject(soloLive, forKey: "solo_live")
        }
        if spreadImageRef != nil {
            aCoder.encodeObject(spreadImageRef, forKey: "spread_image_ref")
        }
        if spriteImageRef != nil {
            aCoder.encodeObject(spriteImageRef, forKey: "sprite_image_ref")
        }
        if starLessonType != nil {
            aCoder.encodeObject(starLessonType, forKey: "star_lesson_type")
        }
        if title != nil {
            aCoder.encodeObject(title, forKey: "title")
        }
        if titleFlag != nil {
            aCoder.encodeObject(titleFlag, forKey: "title_flag")
        }
        if valist != nil {
            aCoder.encodeObject(valist, forKey: "valist")
        }
        if visualMax != nil {
            aCoder.encodeObject(visualMax, forKey: "visual_max")
        }
        if visualMin != nil {
            aCoder.encodeObject(visualMin, forKey: "visual_min")
        }
        if vocalMax != nil {
            aCoder.encodeObject(vocalMax, forKey: "vocal_max")
        }
        if vocalMin != nil {
            aCoder.encodeObject(vocalMin, forKey: "vocal_min")
        }
        
    }
    
}
