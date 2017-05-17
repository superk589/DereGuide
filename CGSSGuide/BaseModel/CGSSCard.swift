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
    
    var attShort: String {
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
            return Color.cute
        case "cool":
            return Color.cool
        case "passion":
            return Color.passion
        default:
            return Color.allType
        }
    }
    
    var gachaType:CGSSAvailableTypes {
        var type: CGSSAvailableTypes
        if availableType != nil {
            type = availableType!
        }
        else if CGSSGameResource.shared.gachaAvailabelList.contains(seriesId) { type = .normal }
        else if CGSSGameResource.shared.fesAvailabelList.contains(seriesId) { type = .fes }
        else if CGSSGameResource.shared.timeLimitAvailableList.contains(seriesId) { type = .limit }
        else if CGSSGameResource.shared.eventAvailabelList.contains(seriesId) { type = .event }
        else { type = .free }
        availableType = type
        return type
    }
    
    var chara: CGSSChar? {
        if let id = charaId {
            return CGSSDAO.shared.findCharById(id)
        }
        return nil
    }
    var leaderSkill: CGSSLeaderSkill? {
        if let id = leaderSkillId {
            return CGSSDAO.shared.findLeaderSkillById(id)
        }
        return nil
    }
    var skill: CGSSSkill? {
        if let id = skillId {
            return CGSSDAO.shared.findSkillById(id)
        }
        return nil
    }
    
    // 对卡片进行按更新时间先后排序时使用, 对于新卡取更新时间, 对于旧卡取id%1000
    dynamic var update_id: Int {
        var returnValue = id! % 1000
        returnValue += Int(updateTime.timeIntervalSince1970)
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
        if let base = danceMax, let bonus = bonusDance {
            return base + bonus
        }
        return 0
    }
    
    dynamic var vocal: Int {
        if let base = vocalMax, let bonus = bonusVocal {
            return base + bonus
        }
        return 0
    }
    dynamic var visual: Int {
        if let base = visualMax, let bonus = bonusVisual {
            return base + bonus
        }
        return 0
    }
    dynamic var life: Int {
        if let base = hpMax, let bonus = bonusHp {
            return base + bonus
        }
        return 0
    }
    
    var appeal: CGSSAppeal {
        return CGSSAppeal(visual: visual, vocal: vocal, dance: dance, life: life)
    }
    
    dynamic var overall: Int {
        if let base = overallMax, let bonus = overallBonus {
            return base + bonus
        }
        return 0
    }
    
    // 用于filter的部分属性
    var rarityType: CGSSRarityTypes {
        return CGSSRarityTypes.init(rarity: rarity.rarity - 1)
    }
   
    var skillType: CGSSSkillTypes {
        return skill?.skillFilterType ?? .none
    }
    var cardType: CGSSCardTypes {
        return CGSSCardTypes.init(typeString: attribute)
    }
    var attributeType: CGSSAttributeTypes {
        if let da = danceMax, let vo = vocalMax, let vi = visualMax {
            if da >= vo && da >= vi {
                return .dance
            } else if vo >= vi && vo >= da {
                return .vocal
            } else {
                return .visual
            }
        }
        return .none
    }

    var favoriteType: CGSSFavoriteTypes {
        return CGSSFavoriteManager.default.contains(cardId: self.id!) ? CGSSFavoriteTypes.inFavorite : CGSSFavoriteTypes.notInFavorite
    }
    
    var spreadImageURL: URL? {
        return URL.init(string: spreadImageRef)
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
    
    // 非JSON获取
    var availableType: CGSSAvailableTypes?
    dynamic var odds = 0
    
    /**
         * Instantiate the instance using the passed json values to set the properties values
         */
    init(fromJson json: JSON!) {
        super.init()
        if json == JSON.null {
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
            valist.append(valistJson.stringValue as AnyObject)
        }
        visualMax = json["visual_max"].intValue
        visualMin = json["visual_min"].intValue
        vocalMax = json["vocal_max"].intValue
        vocalMin = json["vocal_min"].intValue
        
        let dao = CGSSDAO.shared
        let skillJson = json["skill"]
        if skillJson != JSON.null {
            if let skill = dao.findSkillById(skillId), !skill.isOldVersion {
                // skill 存在且不是老版本 则不做任何处理
            } else {
                let skill = CGSSSkill.init(fromJson: skillJson)
                dao.skillDict.setValue(skill, forKey: String(skillId))
            }
        }
        let charaJson = json["chara"]
        if charaJson != JSON.null {
            if let chara = dao.findCharById(charaId), !chara.isOldVersion {
                
            } else {
                let chara = CGSSChar(fromJson: charaJson)
                dao.charDict.setValue(chara, forKey: String(charaId))
            }
        }
        let leadSkillJson = json["lead_skill"]
        if leadSkillJson != JSON.null {
            if let leaderSkill = dao.findLeaderSkillById(leaderSkillId), leaderSkill.isOldVersion {
                
            } else {
                let leadSkill = CGSSLeaderSkill(fromJson: leadSkillJson)
                dao.leaderSkillDict.setValue(leadSkill, forKey: String(leaderSkillId))
            }
        }
    }
    
    /**
         * NSCoding required initializer.
         * Fills the data from the passed decoder
         */
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        albumId = aDecoder.decodeObject(forKey: "album_id") as? Int
        attribute = aDecoder.decodeObject(forKey: "attribute") as? String
        bestStat = aDecoder.decodeObject(forKey: "best_stat") as? Int
        bonusDance = aDecoder.decodeObject(forKey: "bonus_dance") as? Int
        bonusHp = aDecoder.decodeObject(forKey: "bonus_hp") as? Int
        bonusVisual = aDecoder.decodeObject(forKey: "bonus_visual") as? Int
        bonusVocal = aDecoder.decodeObject(forKey: "bonus_vocal") as? Int
        cardImageRef = aDecoder.decodeObject(forKey: "card_image_ref") as? String
        charaId = aDecoder.decodeObject(forKey: "chara_id") as? Int
        danceMax = aDecoder.decodeObject(forKey: "dance_max") as? Int
        danceMin = aDecoder.decodeObject(forKey: "dance_min") as? Int
        evolutionId = aDecoder.decodeObject(forKey: "evolution_id") as? Int
        evolutionType = aDecoder.decodeObject(forKey: "evolution_type") as? Int
        growType = aDecoder.decodeObject(forKey: "grow_type") as? Int
        hasSign = aDecoder.decodeObject(forKey: "has_sign") as? Bool
        hasSpread = aDecoder.decodeObject(forKey: "has_spread") as? Bool
        hpMax = aDecoder.decodeObject(forKey: "hp_max") as? Int
        hpMin = aDecoder.decodeObject(forKey: "hp_min") as? Int
        iconImageRef = aDecoder.decodeObject(forKey: "icon_image_ref") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        leaderSkillId = aDecoder.decodeObject(forKey: "leader_skill_id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        nameOnly = aDecoder.decodeObject(forKey: "name_only") as? String
        openDressId = aDecoder.decodeObject(forKey: "open_dress_id") as? Int
        openStoryId = aDecoder.decodeObject(forKey: "open_story_id") as? Int
        overallBonus = aDecoder.decodeObject(forKey: "overall_bonus") as? Int
        overallMax = aDecoder.decodeObject(forKey: "overall_max") as? Int
        overallMin = aDecoder.decodeObject(forKey: "overall_min") as? Int
        place = aDecoder.decodeObject(forKey: "place") as? Int
        pose = aDecoder.decodeObject(forKey: "pose") as? Int
        rarity = aDecoder.decodeObject(forKey: "rarity") as? CGSSCardRarity
        seriesId = aDecoder.decodeObject(forKey: "series_id") as? Int
        skillId = aDecoder.decodeObject(forKey: "skill_id") as? Int
        soloLive = aDecoder.decodeObject(forKey: "solo_live") as? Int
        spreadImageRef = aDecoder.decodeObject(forKey: "spread_image_ref") as? String
        spriteImageRef = aDecoder.decodeObject(forKey: "sprite_image_ref") as? String
        starLessonType = aDecoder.decodeObject(forKey: "star_lesson_type") as? Int
        title = aDecoder.decodeObject(forKey: "title") as? String
        titleFlag = aDecoder.decodeObject(forKey: "title_flag") as? Int
        valist = aDecoder.decodeObject(forKey: "valist") as? [AnyObject]
        visualMax = aDecoder.decodeObject(forKey: "visual_max") as? Int
        visualMin = aDecoder.decodeObject(forKey: "visual_min") as? Int
        vocalMax = aDecoder.decodeObject(forKey: "vocal_max") as? Int
        vocalMin = aDecoder.decodeObject(forKey: "vocal_min") as? Int
        
        // added in 1.1.3
        // availableTypes = CGSSAvailableTypes.init(rawValue: aDecoder.decodeObject(forKey: "availableTypes") as? UInt ?? 0)
        
    }
    
    /**
         * NSCoding required method.
         * Encodes mode properties into the decoder
         */
    override func encode(with aCoder: NSCoder)
    {
        super.encode(with: aCoder)
        if albumId != nil {
            aCoder.encode(albumId, forKey: "album_id")
        }
        if attribute != nil {
            aCoder.encode(attribute, forKey: "attribute")
        }
        if bestStat != nil {
            aCoder.encode(bestStat, forKey: "best_stat")
        }
        if bonusDance != nil {
            aCoder.encode(bonusDance, forKey: "bonus_dance")
        }
        if bonusHp != nil {
            aCoder.encode(bonusHp, forKey: "bonus_hp")
        }
        if bonusVisual != nil {
            aCoder.encode(bonusVisual, forKey: "bonus_visual")
        }
        if bonusVocal != nil {
            aCoder.encode(bonusVocal, forKey: "bonus_vocal")
        }
        if cardImageRef != nil {
            aCoder.encode(cardImageRef, forKey: "card_image_ref")
        }
        if charaId != nil {
            aCoder.encode(charaId, forKey: "chara_id")
        }
        if danceMax != nil {
            aCoder.encode(danceMax, forKey: "dance_max")
        }
        if danceMin != nil {
            aCoder.encode(danceMin, forKey: "dance_min")
        }
        if evolutionId != nil {
            aCoder.encode(evolutionId, forKey: "evolution_id")
        }
        if evolutionType != nil {
            aCoder.encode(evolutionType, forKey: "evolution_type")
        }
        if growType != nil {
            aCoder.encode(growType, forKey: "grow_type")
        }
        if hasSign != nil {
            aCoder.encode(hasSign, forKey: "has_sign")
        }
        if hasSpread != nil {
            aCoder.encode(hasSpread, forKey: "has_spread")
        }
        if hpMax != nil {
            aCoder.encode(hpMax, forKey: "hp_max")
        }
        if hpMin != nil {
            aCoder.encode(hpMin, forKey: "hp_min")
        }
        if iconImageRef != nil {
            aCoder.encode(iconImageRef, forKey: "icon_image_ref")
        }
        if id != nil {
            aCoder.encode(id, forKey: "id")
        }
        if leaderSkillId != nil {
            aCoder.encode(leaderSkillId, forKey: "leader_skill_id")
        }
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
        if nameOnly != nil {
            aCoder.encode(nameOnly, forKey: "name_only")
        }
        if openDressId != nil {
            aCoder.encode(openDressId, forKey: "open_dress_id")
        }
        if openStoryId != nil {
            aCoder.encode(openStoryId, forKey: "open_story_id")
        }
        if overallBonus != nil {
            aCoder.encode(overallBonus, forKey: "overall_bonus")
        }
        if overallMax != nil {
            aCoder.encode(overallMax, forKey: "overall_max")
        }
        if overallMin != nil {
            aCoder.encode(overallMin, forKey: "overall_min")
        }
        if place != nil {
            aCoder.encode(place, forKey: "place")
        }
        if pose != nil {
            aCoder.encode(pose, forKey: "pose")
        }
        if rarity != nil {
            aCoder.encode(rarity, forKey: "rarity")
        }
        if seriesId != nil {
            aCoder.encode(seriesId, forKey: "series_id")
        }
        if skillId != nil {
            aCoder.encode(skillId, forKey: "skill_id")
        }
        if soloLive != nil {
            aCoder.encode(soloLive, forKey: "solo_live")
        }
        if spreadImageRef != nil {
            aCoder.encode(spreadImageRef, forKey: "spread_image_ref")
        }
        if spriteImageRef != nil {
            aCoder.encode(spriteImageRef, forKey: "sprite_image_ref")
        }
        if starLessonType != nil {
            aCoder.encode(starLessonType, forKey: "star_lesson_type")
        }
        if title != nil {
            aCoder.encode(title, forKey: "title")
        }
        if titleFlag != nil {
            aCoder.encode(titleFlag, forKey: "title_flag")
        }
        if valist != nil {
            aCoder.encode(valist, forKey: "valist")
        }
        if visualMax != nil {
            aCoder.encode(visualMax, forKey: "visual_max")
        }
        if visualMin != nil {
            aCoder.encode(visualMin, forKey: "visual_min")
        }
        if vocalMax != nil {
            aCoder.encode(vocalMax, forKey: "vocal_max")
        }
        if vocalMin != nil {
            aCoder.encode(vocalMin, forKey: "vocal_min")
        }
        
        // added in 1.1.3
//        if availableTypes != nil {
//            aCoder.encode(availableTypes.rawValue, forKey: "availableTypes")
//        }
        
    }
    
}
