//
//  CGSSCard.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

public class CGSSCard: CGSSBaseModel {
    // GET /api/v1/card_t/200167
    //
    // {
    // "result": [
    // {
    static let raritys: [CGSSCardRarity] = {
        var array = [CGSSCardRarity]()
        for i in 1...8 {
            array.append(CGSSCardRarity.init(value: i)!)
        }
        return array
    }()
    
    public dynamic var album_id: Int
    // "album_id": 1680030,
    public var attribute: String!
    public var attShort: String! {
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
    public var attColor: UIColor {
        switch attribute {
        case "cute":
            return CGSSTool.cuteColor
        case "cool":
            return CGSSTool.coolColor
        case "passion":
            return CGSSTool.passionColor
        default:
            return CGSSTool.allTypeColor
        }
    }
    // "attribute": 2,
    // ; Any of "cool", "cute", "passion", "office"
    // ; (last one reserved for Chihiro)
    public var bonus_dance: Int?
    public var bonus_hp: Int?
    // "bonus_dance": 151,
    // "bonus_hp": 2,
    public var bonus_visual: Int?
    // "bonus_visual": 179,
    public var bonus_vocal: Int?
    // "bonus_vocal": 145,
    // ; Increase to appeal after card is fully bonded
    public var card_image_ref: String?
    // "card_image_ref": "/static/sync/card/200167.png",
    // ; Link to an image of the card (thumbnail size)
    // "chara":{
    // "ref": "/api/v1/char_t/168"
    // },
    // public var chara_ref:String?
    public var chara: CGSSChar? {
        if let id = chara_id {
            return CGSSDAO.sharedDAO.findCharById(id)
        }
        return nil
    }
    // "chara_id": 168,
    public var chara_id: Int?
    public var dance_max: Int?
    public var dance_min: Int?
    // "dance_max": 3004,
    // "dance_min": 1562,
    // ; At max and min level. For levels in between, linearly
    // ; Int?erpolate: V(L) = min + (max - min) * (L / max_L)
    // "evolution_id": 200168,
    // ; ID of transformed card
    public var evolution_id: Int?
    // "evolution_type": 8,
    public var evolution_type: Int?
    // "grow_type": 1,
    public var grow_type: Int?
    // "has_spread": true,
    public var has_spread: Bool?
    // ; Whether this card has a full-width image.
    public var hp_max: Int?
    // "hp_max": 39,
    public var hp_min: Int?
    // "hp_min": 39,
    // ; See dance_min
    public var id: Int?
    // "id": 200167,
    public var leader_skill: CGSSLeaderSkill? {
        if let id = leader_skill_id {
            return CGSSDAO.sharedDAO.findLeaderSkillById(id)
        }
        return nil
    }
    // public var lead_skill_ref:String?
    // "lead_skill": {
    // "ref": "/api/v1/leader_skill_t/33"
    // },
    public var leader_skill_id: Int?
    // "leader_skill_id": 33,
    public var name: String?
    // "name": "［黒真珠の輝き］黒川千秋",
    // ; Card title and idol name. We split it for you, see
    // ; name_only and title.
    public var name_only: String?
    // "name_only": "黒川千秋",
    // ; Japanese name of the idol. For english, don't use
    // ; read_tl, use char_t->conventional.
    public var open_dress_id: Int?
    // "open_dress_id": 0,
    // ; Model ID.
    public var open_story_id: Int?
    // "open_story_id": 1477,
    public var overall_bonus: Int?
    // "overall_bonus": 475,
    public var overall_max: Int?
    // "overall_max": 9461,
    public var overall_min: Int?
    // "overall_min": 4920,
    // ; Sum of VoViDa.
    public var place: Int?
    // "place": 128,
    public var pose: Int?
    // "pose": 3,
    // ; This card's (transparent) sprite number. Only unique among
    // ; the idol's sprites.
    public var rarity: CGSSCardRarity? {
        
        return CGSSCard.raritys[rarity_ref - 1]
        
    }
    public dynamic var rarity_ref: Int
    
    // "rarity": {
    // "add_max_level": 0,
    // "add_param": 0,
    // "base_give_exp": 1000,
    // "base_give_money": 5000,
    // "base_max_level": 60,
    // "max_love": 100,
    // "max_star_rank": 20,
    // "rarity": 5
    // ; from 1 = N to 8 = SSR+.
    // },
    // "series_id": 200167,
    public var series_id: Int?
    // ; Evolution chain ID of this card.
    public var skill: CGSSSkill? {
        if let id = skill_id {
            return CGSSDAO.sharedDAO.findSkillById(id)
        }
        return nil
    }
    // public var skill_ref:String?
    // "skill": {
    // "ref": "/api/v1/skill_t/200167"
    // },
    public var skill_id: Int?
    // "skill_id": 200167,
    public var solo_live: Int?
    // "solo_live": 0,
    public var spread_image_ref: String?
    // "spread_image_ref": "/static/sync/spread/200167.png",
    // ; This is null if has_spread is 0.
    public var sprite_image_ref: String?
    public var star_lesson_type: Int?
    // "star_lesson_type": 3,
    public var title: String?
    // "title": "黒真珠の輝き",
    // ; Card title. You can (usually) use read_tl to get its english
    // ; counterpart. null when title_flag is 0.
    public var title_flag: Int?
    // "title_flag": 1,
    // public var valist:[Int]?
    // "valist": [],
    public var visual_max: Int?
    // "visual_max": 3565,
    public var visual_min: Int?
    // "visual_min": 1854,
    public var vocal_max: Int?
    // "vocal_max": 2892,
    public var vocal_min: Int?
    // "vocal_min": 1504
    // ; see dance_min
    
    // 对卡片进行按更新时间先后排序时使用, 对于新卡取更新时间, 对于旧卡取id%1000
    public dynamic var update_id: Int {
        var returnValue: Int
        
        if evolution_id != 0 {
            returnValue = evolution_id! % 1000
        } else {
            returnValue = id! % 1000
        }
        if let date = updateTime {
            returnValue += Int(date.timeIntervalSince1970)
        }
        return returnValue
    }
    //
    public dynamic var dance: Int {
        if let base = dance_max, bonus = bonus_dance {
            return base + bonus
        }
        return 0
    }
    
    public dynamic var vocal: Int {
        if let base = vocal_max, bonus = bonus_vocal {
            return base + bonus
        }
        return 0
    }
    public dynamic var visual: Int {
        if let base = visual_max, bonus = bonus_visual {
            return base + bonus
        }
        return 0
    }
    public dynamic var life: Int {
        if let base = hp_max, bonus = bonus_hp {
            return base + bonus
        }
        return 0
    }
    
    public dynamic var overall: Int {
        if let base = overall_max, bonus = overall_bonus {
            return base + bonus
        }
        return 0
    }
    
    // 用于filter的部分属性
    var rarityFilterType: CGSSCardRarityFilterType {
        
        return CGSSCardRarityFilterType.init(rarity: rarity_ref - 1) ?? CGSSCardRarityFilterType.N
        
    }
    var cardFilterType: CGSSCardFilterType {
        return CGSSCardFilterType.init(typeString: attribute)!
    }
    var attributeFilterType: CGSSAttributeFilterType {
        if let da = dance_max, let vo = vocal_max, let vi = visual_max {
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
        return CGSSFavoriteManager.defaultManager.contains(self.id!) ? CGSSFavoriteFilterType.InFavorite : CGSSFavoriteFilterType.NotInFavorite
    }
    
    public override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(album_id, forKey: "album_id")
        aCoder.encodeObject(attribute, forKey: "attribute")
        aCoder.encodeObject(bonus_dance, forKey: "bonus_dance")
        aCoder.encodeObject(bonus_hp, forKey: "bonus_hp")
        aCoder.encodeObject(bonus_visual, forKey: "bonus_visual")
        aCoder.encodeObject(bonus_vocal, forKey: "bonus_vocal")
        // "bonus_dance": 151,
        // "bonus_hp": 2,
        // "bonus_visual": 179,
        // "bonus_vocal": 145,
        // ; Increase to appeal after card is fully bonded
        aCoder.encodeObject(card_image_ref, forKey: "card_image_ref")
        // "card_image_ref": "/static/sync/card/200167.png",
        // ; Link to an image of the card (thumbnail size)
        // "chara": {
        // "ref": "/api/v1/char_t/168"
        // },
        // aCoder.encodeObject(chara_ref, forKey: "chara_ref")
        aCoder.encodeObject(chara_id, forKey: "chara_id")
        // "chara_id": 168,
        aCoder.encodeObject(dance_max, forKey: "dance_max")
        aCoder.encodeObject(dance_min, forKey: "dance_min")
        // "dance_max": 3004,
        // "dance_min": 1562,
        // ; At max and min level. For levels in between, linearly
        // ; interpolate: V(L) = min + (max - min) * (L / max_L)
        // "evolution_id": 200168,
        aCoder.encodeObject(evolution_id, forKey: "evolution_id")
        aCoder.encodeObject(evolution_type, forKey: "evoltion_type")
        // ; ID of transformed card
        // "evolution_type": 8,
        aCoder.encodeObject(grow_type, forKey: "grow_type")
        // "grow_type": 1,
        aCoder.encodeObject(has_spread, forKey: "has_spread")
        aCoder.encodeObject(hp_max, forKey: "hp_max")
        aCoder.encodeObject(hp_min, forKey: "hp_min")
        // "has_spread": true,
        // ; Whether this card has a full-width image.
        // "hp_max": 39,
        // "hp_min": 39,
        // ; See dance_min
        aCoder.encodeObject(id, forKey: "id")
        // aCoder.encodeObject(lead_skill_ref, forKey: "lead_skill_ref")
        // "id": 200167,
        // "lead_skill": {
        // "ref": "/api/v1/leader_skill_t/33"
        // },
        aCoder.encodeObject(leader_skill_id, forKey: "leader_skill_id")
        // "leader_skill_id": 33,
        aCoder.encodeObject(name, forKey: "name")
        // "name": "［黒真珠の輝き］黒川千秋",
        // ; Card title and idol name. We split it for you, see
        // ; name_only and title.
        aCoder.encodeObject(name_only, forKey: "name_only")
        // "name_only": "黒川千秋",
        // ; Japanese name of the idol. For english, don't use
        // ; read_tl, use char_t->conventional.
        // "open_dress_id": 0,
        aCoder.encodeObject(open_dress_id, forKey: "open_dress_id")
        // ; Model ID.
        aCoder.encodeObject(open_story_id, forKey: "open_story_id")
        // "open_story_id": 1477,
        aCoder.encodeObject(overall_max, forKey: "overall_max")
        aCoder.encodeObject(overall_min, forKey: "overall_min")
        aCoder.encodeObject(overall_bonus, forKey: "overall_bonus")
        // "overall_bonus": 475,
        // "overall_max": 9461,
        // "overall_min": 4920,
        // ; Sum of VoViDa.
        aCoder.encodeObject(place, forKey: "place")
        // "place": 128,
        aCoder.encodeObject(pose, forKey: "pose")
        // "pose": 3,
        // ; This card's (transparent) sprite number. Only unique among
        // ; the idol's sprites.
        aCoder.encodeObject(rarity_ref, forKey: "rarity_ref")
        // "rarity": {
        // "add_max_level": 0,
        // "add_param": 0,
        // "base_give_exp": 1000,
        // "base_give_money": 5000,
        // "base_max_level": 60,
        // "max_love": 100,
        // "max_star_rank": 20,
        // "rarity": 5
        // ; from 1 = N to 8 = SSR+.
        // },
        aCoder.encodeObject(series_id, forKey: "series_id")
        // "series_id": 200167,
        // ; Evolution chain ID of this card.
        // aCoder.encodeObject(skill_ref, forKey: "skill_ref")
        // "skill": {
        // "ref": "/api/v1/skill_t/200167"
        // },
        aCoder.encodeObject(skill_id, forKey: "skill_id")
        // "skill_id": 200167,
        aCoder.encodeObject(solo_live, forKey: "solo_live")
        // "solo_live": 0,
        // "spread_image_ref": "/static/sync/spread/200167.png",
        aCoder.encodeObject(spread_image_ref, forKey: "spread_image_ref")
        // ; This is null if has_spread is 0.
        aCoder.encodeObject(sprite_image_ref, forKey: "sprite_image_ref")
        aCoder.encodeObject(star_lesson_type, forKey: "star_lesson_type")
        // "star_lesson_type": 3,
        aCoder.encodeObject(title, forKey: "title")
        // "title": "黒真珠の輝き",
        // ; Card title. You can (usually) use read_tl to get its english
        // ; counterpart. null when title_flag is 0.
        aCoder.encodeObject(title_flag, forKey: "title_flag")
        // "title_flag": 1,
        // aCoder.encodeObject(valist)
        // "valist": [],
        aCoder.encodeObject(visual_max, forKey: "visual_max")
        // "visual_max": 3565,
        aCoder.encodeObject(visual_min, forKey: "visual_min")
        // "visual_min": 1854,
        aCoder.encodeObject(vocal_max, forKey: "vocal_max")
        // "vocal_max": 2892,
        aCoder.encodeObject(vocal_min, forKey: "vocal_min")
        // "vocal_min": 1504
        // ; see dance_min
    }
    
    public init(album_id: Int, attribute: String?, bonus_dance: Int?, bonus_hp: Int?, bonus_visual: Int?, bonus_vocal: Int?, card_image_ref: String?, chara_id: Int?, dance_max: Int?, dance_min: Int?, evolution_id: Int?, evolution_type: Int?, grow_type: Int?, has_spread: Bool?, hp_max: Int?, hp_min: Int?, id: Int?, leader_skill_id: Int?, name: String?, name_only: String?, open_dress_id: Int?, open_story_id: Int?, overall_max: Int?, overall_min: Int?, overall_bonus: Int?, place: Int?, pose: Int?, rarity_ref: Int, series_id: Int?, skill_id: Int?, solo_live: Int?, spread_image_ref: String?, sprite_image_ref: String?, star_lesson_type: Int?, title: String?, title_flag: Int?, visual_max: Int?, visual_min: Int?, vocal_max: Int?, vocal_min: Int?) {
        self.album_id = album_id
        self.attribute = attribute
        self.bonus_dance = bonus_dance
        self.bonus_hp = bonus_hp
        self.bonus_visual = bonus_visual
        self.bonus_vocal = bonus_vocal
        // "bonus_dance": 151,
        // "bonus_hp": 2,
        // "bonus_visual": 179,
        // "bonus_vocal": 145,
        // ; Increase to appeal after card is fully bonded
        self.card_image_ref = card_image_ref
        // "card_image_ref": "/static/sync/card/200167.png",
        // ; Link to an image of the card ("thumbnail size")
        // "chara": {
        // "ref": "/api/v1/char_t/168"
        // },
        // self.chara_ref = chara_ref
        self.chara_id = chara_id
        // "chara_id": 168,
        self.dance_max = dance_max
        self.dance_min = dance_min
        // "dance_max": 3004,
        // "dance_min": 1562,
        // ; At max and min level. For levels in between, linearly
        // ; interpolate: V("L") = min + ("max - min") * ("L / max_L")
        // "evolution_id": 200168,
        self.evolution_id = evolution_id
        self.evolution_type = evolution_type
        // ; ID of transformed card
        // "evolution_type": 8,
        self.grow_type = grow_type
        // "grow_type": 1,
        self.has_spread = has_spread
        self.hp_max = hp_max
        self.hp_min = hp_min
        // "has_spread": true,
        // ; Whether this card has a full-width image.
        // "hp_max": 39,
        // "hp_min": 39,
        // ; See dance_min
        self.id = id
        // self.lead_skill_ref = lead_skill_ref
        // "id": 200167,
        // "lead_skill": {
        // "ref": "/api/v1/leader_skill_t/33"
        // },
        self.leader_skill_id = leader_skill_id
        // "leader_skill_id": 33,
        self.name = name
        // "name": "［黒真珠の輝き］黒川千秋",
        // ; Card title and idol name. We split it for you, see
        // ; name_only and title.
        self.name_only = name_only
        // "name_only": "黒川千秋",
        // ; Japanese name of the idol. For english, don't use
        // ; read_tl, use char_t->conventional.
        // "open_dress_id": 0,
        self.open_dress_id = open_dress_id
        // ; Model ID.
        self.open_story_id = open_story_id
        // "open_story_id": 1477,
        self.overall_max = overall_max
        self.overall_min = overall_min
        self.overall_bonus = overall_bonus
        // "overall_bonus": 475,
        // "overall_max": 9461,
        // "overall_min": 4920,
        // ; Sum of VoViDa.
        self.place = place
        // "place": 128,
        self.pose = pose
        // "pose": 3,
        // ; This card's ("transparent") sprite number. Only unique among
        // ; the idol's sprites.
        self.rarity_ref = rarity_ref
        // "rarity": {
        // "add_max_level": 0,
        // "add_param": 0,
        // "base_give_exp": 1000,
        // "base_give_money": 5000,
        // "base_max_level": 60,
        // "max_love": 100,
        // "max_star_rank": 20,
        // "rarity": 5
        // ; from 1 = N to 8 = SSR+.
        // },
        self.series_id = series_id
        // "series_id": 200167,
        // ; Evolution chain ID of this card.
        // self.skill_ref = skill_ref
        // "skill": {
        // "ref": "/api/v1/skill_t/200167"
        // },
        self.skill_id = skill_id
        // "skill_id": 200167,
        self.solo_live = solo_live
        // "solo_live": 0,
        // "spread_image_ref": "/static/sync/spread/200167.png",
        self.spread_image_ref = spread_image_ref
        self.sprite_image_ref = sprite_image_ref
        // ; This is null if has_spread is 0.
        self.star_lesson_type = star_lesson_type
        // "star_lesson_type": 3,
        self.title = title
        // "title": "黒真珠の輝き",
        // ; Card title. You can ("usually") use read_tl to get its english
        // ; counterpart. null when title_flag is 0.
        self.title_flag = title_flag
        // "title_flag": 1,
        // self.valist = valist
        // "valist": [],
        self.visual_max = visual_max
        // "visual_max": 3565,
        self.visual_min = visual_min
        // "visual_min": 1854,
        self.vocal_max = vocal_max
        // "vocal_max": 2892,
        self.vocal_min = vocal_min
        // "vocal_min": 1504
        //
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.album_id = aDecoder.decodeObjectForKey("album_id") as? Int ?? 999999
        self.attribute = aDecoder.decodeObjectForKey("attribute") as? String
        self.bonus_dance = aDecoder.decodeObjectForKey("bonus_dance") as? Int
        self.bonus_hp = aDecoder.decodeObjectForKey("bonus_hp") as? Int
        self.bonus_visual = aDecoder.decodeObjectForKey("bonus_visual") as? Int
        self.bonus_vocal = aDecoder.decodeObjectForKey("bonus_vocal") as? Int
        // "bonus_dance": 151,
        // "bonus_hp": 2,
        // "bonus_visual": 179,
        // "bonus_vocal": 145,
        // ; Increase to appeal after card is fully bonded
        self.card_image_ref = aDecoder.decodeObjectForKey("card_image_ref") as? String
        // "card_image_ref": "/static/sync/card/200167.png",
        // ; Link to an image of the card ("thumbnail size")
        // "chara": {
        // "ref": "/api/v1/char_t/168"
        // },
        // self.chara_ref = aDecoder.decodeObjectForKey("chara_ref") as? String
        self.chara_id = aDecoder.decodeObjectForKey("chara_id") as? Int
        // "chara_id": 168,
        self.dance_max = aDecoder.decodeObjectForKey("dance_max") as? Int
        self.dance_min = aDecoder.decodeObjectForKey("dance_min") as? Int
        // "dance_max": 3004,
        // "dance_min": 1562,
        // ; At max and min level. For levels in between, linearly
        // ; interpolate: V("L") = min + ("max - min") * ("L / max_L")
        // "evolution_id": 200168,
        self.evolution_id = aDecoder.decodeObjectForKey("evolution_id") as? Int
        self.evolution_type = aDecoder.decodeObjectForKey("evolution_type") as? Int
        // ; ID of transformed card
        // "evolution_type": 8,
        self.grow_type = aDecoder.decodeObjectForKey("grow_type") as? Int
        // "grow_type": 1,
        self.has_spread = aDecoder.decodeObjectForKey("has_spread") as? Bool
        self.hp_max = aDecoder.decodeObjectForKey("hp_max") as? Int
        self.hp_min = aDecoder.decodeObjectForKey("hp_min") as? Int
        // "has_spread": true,
        // ; Whether this card has a full-width image.
        // "hp_max": 39,
        // "hp_min": 39,
        // ; See dance_min
        self.id = aDecoder.decodeObjectForKey("id") as? Int
        // self.lead_skill_ref = aDecoder.decodeObjectForKey("lead_skill_ref") as? String
        // "id": 200167,
        // "lead_skill": {
        // "ref": "/api/v1/leader_skill_t/33"
        // },
        self.leader_skill_id = aDecoder.decodeObjectForKey("leader_skill_id") as? Int
        // "leader_skill_id": 33,
        self.name = aDecoder.decodeObjectForKey("name") as? String
        // "name": "［黒真珠の輝き］黒川千秋",
        // ; Card title and idol name. We split it for you, see
        // ; name_only and title.
        self.name_only = aDecoder.decodeObjectForKey("name_only") as? String
        // "name_only": "黒川千秋",
        // ; Japanese name of the idol. For english, don't use
        // ; read_tl, use char_t->conventional.
        // "open_dress_id": 0,
        self.open_dress_id = aDecoder.decodeObjectForKey("open_dress_id") as? Int
        // ; Model ID.
        self.open_story_id = aDecoder.decodeObjectForKey("open_story_id") as? Int
        // "open_story_id": 1477,
        self.overall_max = aDecoder.decodeObjectForKey("overall_max") as? Int
        self.overall_min = aDecoder.decodeObjectForKey("overall_min") as? Int
        self.overall_bonus = aDecoder.decodeObjectForKey("overall_bonus") as? Int
        // "overall_bonus": 475,
        // "overall_max": 9461,
        // "overall_min": 4920,
        // ; Sum of VoViDa.
        self.place = aDecoder.decodeObjectForKey("place") as? Int
        // "place": 128,
        self.pose = aDecoder.decodeObjectForKey("pose") as? Int
        // "pose": 3,
        // ; This card's ("transparent") sprite number. Only unique among
        // ; the idol's sprites.
        self.rarity_ref = aDecoder.decodeObjectForKey("rarity_ref") as? Int ?? 1
        // "rarity": {
        // "add_max_level": 0,
        // "add_param": 0,
        // "base_give_exp": 1000,
        // "base_give_money": 5000,
        // "base_max_level": 60,
        // "max_love": 100,
        // "max_star_rank": 20,
        // "rarity": 5
        // ; from 1 = N to 8 = SSR+.
        // },
        self.series_id = aDecoder.decodeObjectForKey("series_id") as? Int
        // "series_id": 200167,
        // ; Evolution chain ID of this card.
        // self.skill_ref = aDecoder.decodeObjectForKey("skill_ref") as? String
        // "skill": {
        // "ref": "/api/v1/skill_t/200167"
        // },
        self.skill_id = aDecoder.decodeObjectForKey("skill_id") as? Int
        // "skill_id": 200167,
        self.solo_live = aDecoder.decodeObjectForKey("solo_live") as? Int
        // "solo_live": 0,
        // "spread_image_ref": "/static/sync/spread/200167.png",
        self.spread_image_ref = aDecoder.decodeObjectForKey("spread_image_ref") as? String
        self.sprite_image_ref = aDecoder.decodeObjectForKey("sprite_image_ref") as? String
        // ; This is null if has_spread is 0.
        self.star_lesson_type = aDecoder.decodeObjectForKey("star_lesson_type") as? Int
        // "star_lesson_type": 3,
        self.title = aDecoder.decodeObjectForKey("title") as? String
        // "title": "黒真珠の輝き",
        // ; Card title. You can ("usually") use read_tl to get its english
        // ; counterpart. null when title_flag is 0.
        self.title_flag = aDecoder.decodeObjectForKey("title_flag") as? Int
        // "title_flag": 1,
        // self.valist = aDecoder.decodeObjectForKey("valist") as? [Int]
        // "valist": [],
        self.visual_max = aDecoder.decodeObjectForKey("visual_max") as? Int
        // "visual_max": 3565,
        self.visual_min = aDecoder.decodeObjectForKey("visual_min") as? Int
        // "visual_min": 1854,
        self.vocal_max = aDecoder.decodeObjectForKey("vocal_max") as? Int
        // "vocal_max": 2892,
        self.vocal_min = aDecoder.decodeObjectForKey("vocal_min") as? Int
        // "vocal_min": 1504
        // ; see dance_min
        super.init(coder: aDecoder)
//
        
    }
    public convenience init?(jsonData: NSData) {
        let jsonObj = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
        
        if let root = jsonObj as? NSDictionary {
            if let result = root["result"] as? NSArray {
                if let root2 = result[0] as? NSDictionary {
                    let album_id = root2["album_id"] as? Int ?? 999999
                    let attribute = root2["attribute"] as? String
                    let bonus_dance = root2["bonus_dance"] as? Int
                    let bonus_hp = root2["bonus_hp"] as? Int
                    let bonus_visual = root2["bonus_visual"] as? Int
                    let bonus_vocal = root2["bonus_vocal"] as? Int
                    // "bonus_dance": 151,
                    // "bonus_hp": 2,
                    // "bonus_visual": 179,
                    // "bonus_vocal": 145,
                    // ; Increase to appeal after card is fully bonded
                    let card_image_ref = root2["card_image_ref"] as? String
                    // "card_image_ref": "/static/sync/card/200167.png",
                    // ; Link to an image of the card ["thumbnail size"]
                    // "chara": {
                    // "ref": "/api/v1/char_t/168"
                    // },
                    
                    let chara_id = root2["chara_id"] as? Int
                    // "chara_id": 168,
                    let dance_max = root2["dance_max"] as? Int
                    let dance_min = root2["dance_min"] as? Int
                    // "dance_max": 3004,
                    // "dance_min": 1562,
                    // ; At max and min level. For levels in between, linearly
                    // ; interpolate: V["L"] = min + ["max - min"] * ["L / max_L"]
                    // "evolution_id": 200168,
                    let evolution_id = root2["evolution_id"] as? Int
                    let evolution_type = root2["evolution_type"] as? Int
                    // ; ID of transformed card
                    // "evolution_type": 8,
                    let grow_type = root2["grow_type"] as? Int
                    // "grow_type": 1,
                    let has_spread = root2["has_spread"] as? Bool
                    let hp_max = root2["hp_max"] as? Int
                    let hp_min = root2["hp_min"] as? Int
                    // "has_spread": true,
                    // ; Whether this card has a full-width image.
                    // "hp_max": 39,
                    // "hp_min": 39,
                    // ; See dance_min
                    let id = root2["id"] as? Int
                    // "id": 200167,
                    // "lead_skill": {
                    // "ref": "/api/v1/leader_skill_t/33"
                    // },
                    let leader_skill_id = root2["leader_skill_id"] as? Int
                    // "leader_skill_id": 33,
                    let name = root2["name"] as? String
                    // "name": "［黒真珠の輝き］黒川千秋",
                    // ; Card title and idol name. We split it for you, see
                    // ; name_only and title.
                    let name_only = root2["name_only"] as? String
                    // "name_only": "黒川千秋",
                    // ; Japanese name of the idol. For english, don't use
                    // ; read_tl, use char_t->conventional.
                    // "open_dress_id": 0,
                    let open_dress_id = root2["open_dress_id"] as? Int
                    // ; Model ID.
                    let open_story_id = root2["open_story_id"] as? Int
                    // "open_story_id": 1477,
                    let overall_max = root2["overall_max"] as? Int
                    let overall_min = root2["overall_min"] as? Int
                    let overall_bonus = root2["overall_bonus"] as? Int
                    // "overall_bonus": 475,
                    // "overall_max": 9461,
                    // "overall_min": 4920,
                    // ; Sum of VoViDa.
                    let place = root2["place"] as? Int
                    // "place": 128,
                    let pose = root2["pose"] as? Int
                    // "pose": 3,
                    // ; This card's ["transparent"] sprite number. Only unique among
                    // ; the idol's sprites.
                    var rarity_ref: Int
                    if let rarity = root2["rarity"] as? NSDictionary {
                        rarity_ref = rarity["rarity"] as? Int ?? 1
                    } else {
                        rarity_ref = 1
                    }
                    // "rarity": {
                    // "add_max_level": 0,
                    // "add_param": 0,
                    // "base_give_exp": 1000,
                    // "base_give_money": 5000,
                    // "base_max_level": 60,
                    // "max_love": 100,
                    // "max_star_rank": 20,
                    // "rarity": 5
                    // ; from 1 = N to 8 = SSR+.
                    // },
                    let series_id = root2["series_id"] as? Int
                    // "series_id": 200167,
                    // ; Evolution chain ID of this card.
                    // "skill": {
                    // "ref": "/api/v1/skill_t/200167"
                    // },
                    let skill_id = root2["skill_id"] as? Int
                    // "skill_id": 200167,
                    let solo_live = root2["solo_live"] as? Int
                    // "solo_live": 0,
                    // "spread_image_ref": "/static/sync/spread/200167.png",
                    let spread_image_ref = root2["spread_image_ref"] as? String
                    // ; This is null if has_spread is 0.
                    let sprite_image_ref = root2["sprite_image_ref"] as? String
                    let star_lesson_type = root2["star_lesson_type"] as? Int
                    // "star_lesson_type": 3,
                    let title = root2["title"] as? String
                    // "title": "黒真珠の輝き",
                    // ; Card title. You can ["usually"] use read_tl to get its english
                    // ; counterpart. null when title_flag is 0.
                    let title_flag = root2["title_flag"] as? Int
                    // "title_flag": 1,
                    // "valist": [],
                    let visual_max = root2["visual_max"] as? Int
                    // "visual_max": 3565,
                    let visual_min = root2["visual_min"] as? Int
                    // "visual_min": 1854,
                    let vocal_max = root2["vocal_max"] as? Int
                    // "vocal_max": 2892,
                    let vocal_min = root2["vocal_min"] as? Int
                    // "vocal_min": 1504
                    // ; see dance_min
                    self.init(album_id: album_id, attribute: attribute, bonus_dance: bonus_dance, bonus_hp: bonus_hp, bonus_visual: bonus_visual, bonus_vocal: bonus_vocal, card_image_ref: card_image_ref, chara_id: chara_id, dance_max: dance_max, dance_min: dance_min, evolution_id: evolution_id, evolution_type: evolution_type, grow_type: grow_type, has_spread: has_spread, hp_max: hp_max, hp_min: hp_min, id: id, leader_skill_id: leader_skill_id, name: name, name_only: name_only, open_dress_id: open_dress_id, open_story_id: open_story_id, overall_max: overall_max, overall_min: overall_min, overall_bonus: overall_bonus, place: place, pose: pose, rarity_ref: rarity_ref, series_id: series_id, skill_id: skill_id, solo_live: solo_live, spread_image_ref: spread_image_ref, sprite_image_ref: sprite_image_ref, star_lesson_type: star_lesson_type, title: title, title_flag: title_flag, visual_max: visual_max, visual_min: visual_min, vocal_max: vocal_max, vocal_min: vocal_min)
                    let dao = CGSSDAO.sharedDAO
                    if dao.findSkillById(skill_id!) == nil {
                        if let skill = CGSSSkill.init(attList: root2["skill"] as? NSDictionary) {
                            dao.skillDict.setValue(skill, forKey: String(skill_id!))
                        }
                    }
                    if dao.findLeaderSkillById(leader_skill_id!) == nil {
                        if let leaderSkill = CGSSLeaderSkill.init(attList: root2["lead_skill"] as? NSDictionary) {
                            dao.leaderSkillDict.setValue(leaderSkill, forKey: String(leader_skill_id!))
                        }
                    }
                    
                    if dao.findCharById(chara_id!) == nil {
                        if let char = CGSSChar.init(attList: root2["chara"] as? NSDictionary) {
                            dao.charDict.setValue(char, forKey: String(chara_id!))
                        }
                    }
                    
                    return
                }
            }
        }
        return nil
    }
}

