//
//  CGSSChar.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

extension CGSSChar {
    var attColor: UIColor {
        switch type {
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
    var charFilterType: CGSSCharFilterType {
        return CGSSCharFilterType.init(typeString: type) ?? CGSSCharFilterType.Office
    }
    var charAgeFilterType: CGSSCharAgeFilterType {
        return CGSSCharAgeFilterType.init(age: age)
    }
    var charBloodFilterType: CGSSCharBloodFilterType {
        return CGSSCharBloodFilterType.init(bloodType: bloodType)
    }
    var charCVFilterType: CGSSCharCVTypeFilter {
        return voice == "" ? CGSSCharCVTypeFilter.NO : CGSSCharCVTypeFilter.YES
    }
    
    // 用于排序的动态属性
    dynamic var sHeight: Int {
        return height
    }
    dynamic var sWeight: Int {
        return weight
    }
    dynamic var sAge: Int {
        return age
    }
    dynamic var sizeB: Int {
        return bodySize1
    }
    dynamic var sizeW: Int {
        return bodySize2
    }
    dynamic var sizeH: Int {
        return bodySize3
    }
    dynamic var sName: String {
        return nameKana
    }
    dynamic var sCharaId: Int {
        return charaId
    }
}
class CGSSChar: CGSSBaseModel {
    
    var age: Int!
    var birthDay: Int!
    var birthMonth: Int!
    var bloodType: Int!
    var bodySize1: Int!
    var bodySize2: Int!
    var bodySize3: Int!
    var charaId: Int!
    var constellation: Int!
    var conventional: String!
    var favorite: String!
    var hand: Int!
    var height: Int!
    var homeTown: Int!
    var iconImageRef: String!
    var kanaSpaced: String!
    var kanjiSpaced: String!
    var modelBustId: Int!
    var modelHeightId: Int!
    var modelSkinId: Int!
    var modelWeightId: Int!
    var name: String!
    var nameKana: String!
    var personality: Int!
    var spineSize: Int!
    // 中文版数据库独有
    var translated: String!
    var translatedCht: String!
    //
    var type: String!
    var valist: [AnyObject]!
    var voice: String!
    var weight: Int!
    
    /**
         * Instantiate the instance using the passed json values to set the properties values
         */
    init(fromJson json: JSON!) {
        super.init()
        if json == nil {
            return
        }
        age = json["age"].intValue
        birthDay = json["birth_day"].intValue
        birthMonth = json["birth_month"].intValue
        bloodType = json["blood_type"].intValue
        bodySize1 = json["body_size_1"].intValue
        bodySize2 = json["body_size_2"].intValue
        bodySize3 = json["body_size_3"].intValue
        charaId = json["chara_id"].intValue
        constellation = json["constellation"].intValue
        conventional = json["conventional"].stringValue
        favorite = json["favorite"].stringValue
        hand = json["hand"].intValue
        height = json["height"].intValue
        homeTown = json["home_town"].intValue
        iconImageRef = json["icon_image_ref"].stringValue
        kanaSpaced = json["kana_spaced"].stringValue
        kanjiSpaced = json["kanji_spaced"].stringValue
        modelBustId = json["model_bust_id"].intValue
        modelHeightId = json["model_height_id"].intValue
        modelSkinId = json["model_skin_id"].intValue
        modelWeightId = json["model_weight_id"].intValue
        name = json["name"].stringValue
        nameKana = json["name_kana"].stringValue
        personality = json["personality"].intValue
        spineSize = json["spine_size"].intValue
        translated = json["translated"].stringValue
        translatedCht = json["translated_cht"].stringValue
        type = json["type"].stringValue
        valist = [AnyObject]()
        let valistArray = json["valist"].arrayValue
        for valistJson in valistArray {
            valist.append(valistJson.stringValue)
        }
        voice = json["voice"].stringValue
        weight = json["weight"].intValue
    }
    
    // 用于创建一个空角色, 生日提醒中使用
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        age = aDecoder.decodeObjectForKey("age") as? Int
        birthDay = aDecoder.decodeObjectForKey("birth_day") as? Int
        birthMonth = aDecoder.decodeObjectForKey("birth_month") as? Int
        bloodType = aDecoder.decodeObjectForKey("blood_type") as? Int
        bodySize1 = aDecoder.decodeObjectForKey("body_size_1") as? Int
        bodySize2 = aDecoder.decodeObjectForKey("body_size_2") as? Int
        bodySize3 = aDecoder.decodeObjectForKey("body_size_3") as? Int
        charaId = aDecoder.decodeObjectForKey("chara_id") as? Int
        constellation = aDecoder.decodeObjectForKey("constellation") as? Int
        conventional = aDecoder.decodeObjectForKey("conventional") as? String
        favorite = aDecoder.decodeObjectForKey("favorite") as? String
        hand = aDecoder.decodeObjectForKey("hand") as? Int
        height = aDecoder.decodeObjectForKey("height") as? Int
        homeTown = aDecoder.decodeObjectForKey("home_town") as? Int
        iconImageRef = aDecoder.decodeObjectForKey("icon_image_ref") as? String
        kanaSpaced = aDecoder.decodeObjectForKey("kana_spaced") as? String
        kanjiSpaced = aDecoder.decodeObjectForKey("kanji_spaced") as? String
        modelBustId = aDecoder.decodeObjectForKey("model_bust_id") as? Int
        modelHeightId = aDecoder.decodeObjectForKey("model_height_id") as? Int
        modelSkinId = aDecoder.decodeObjectForKey("model_skin_id") as? Int
        modelWeightId = aDecoder.decodeObjectForKey("model_weight_id") as? Int
        name = aDecoder.decodeObjectForKey("name") as? String
        nameKana = aDecoder.decodeObjectForKey("name_kana") as? String
        personality = aDecoder.decodeObjectForKey("personality") as? Int
        spineSize = aDecoder.decodeObjectForKey("spine_size") as? Int
        translated = aDecoder.decodeObjectForKey("translated") as? String
        translatedCht = aDecoder.decodeObjectForKey("translated_cht") as? String
        type = aDecoder.decodeObjectForKey("type") as? String
        valist = aDecoder.decodeObjectForKey("valist") as? [AnyObject]
        voice = aDecoder.decodeObjectForKey("voice") as? String
        weight = aDecoder.decodeObjectForKey("weight") as? Int
    }
    
    /**
         * NSCoding required method.
         * Encodes mode properties into the decoder
         */
    override func encodeWithCoder(aCoder: NSCoder)
    {
        super.encodeWithCoder(aCoder)
        if age != nil {
            aCoder.encodeObject(age, forKey: "age")
        }
        if birthDay != nil {
            aCoder.encodeObject(birthDay, forKey: "birth_day")
        }
        if birthMonth != nil {
            aCoder.encodeObject(birthMonth, forKey: "birth_month")
        }
        if bloodType != nil {
            aCoder.encodeObject(bloodType, forKey: "blood_type")
        }
        if bodySize1 != nil {
            aCoder.encodeObject(bodySize1, forKey: "body_size_1")
        }
        if bodySize2 != nil {
            aCoder.encodeObject(bodySize2, forKey: "body_size_2")
        }
        if bodySize3 != nil {
            aCoder.encodeObject(bodySize3, forKey: "body_size_3")
        }
        if charaId != nil {
            aCoder.encodeObject(charaId, forKey: "chara_id")
        }
        if constellation != nil {
            aCoder.encodeObject(constellation, forKey: "constellation")
        }
        if conventional != nil {
            aCoder.encodeObject(conventional, forKey: "conventional")
        }
        if favorite != nil {
            aCoder.encodeObject(favorite, forKey: "favorite")
        }
        if hand != nil {
            aCoder.encodeObject(hand, forKey: "hand")
        }
        if height != nil {
            aCoder.encodeObject(height, forKey: "height")
        }
        if homeTown != nil {
            aCoder.encodeObject(homeTown, forKey: "home_town")
        }
        if iconImageRef != nil {
            aCoder.encodeObject(iconImageRef, forKey: "icon_image_ref")
        }
        if kanaSpaced != nil {
            aCoder.encodeObject(kanaSpaced, forKey: "kana_spaced")
        }
        if kanjiSpaced != nil {
            aCoder.encodeObject(kanjiSpaced, forKey: "kanji_spaced")
        }
        if modelBustId != nil {
            aCoder.encodeObject(modelBustId, forKey: "model_bust_id")
        }
        if modelHeightId != nil {
            aCoder.encodeObject(modelHeightId, forKey: "model_height_id")
        }
        if modelSkinId != nil {
            aCoder.encodeObject(modelSkinId, forKey: "model_skin_id")
        }
        if modelWeightId != nil {
            aCoder.encodeObject(modelWeightId, forKey: "model_weight_id")
        }
        if name != nil {
            aCoder.encodeObject(name, forKey: "name")
        }
        if nameKana != nil {
            aCoder.encodeObject(nameKana, forKey: "name_kana")
        }
        if personality != nil {
            aCoder.encodeObject(personality, forKey: "personality")
        }
        if spineSize != nil {
            aCoder.encodeObject(spineSize, forKey: "spine_size")
        }
        if translated != nil {
            aCoder.encodeObject(translated, forKey: "translated")
        }
        if translatedCht != nil {
            aCoder.encodeObject(translatedCht, forKey: "translated_cht")
        }
        if type != nil {
            aCoder.encodeObject(type, forKey: "type")
        }
        if valist != nil {
            aCoder.encodeObject(valist, forKey: "valist")
        }
        if voice != nil {
            aCoder.encodeObject(voice, forKey: "voice")
        }
        if weight != nil {
            aCoder.encodeObject(weight, forKey: "weight")
        }
        
    }
    
}
