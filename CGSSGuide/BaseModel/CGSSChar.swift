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
            return Color.cute
        case "cool":
            return Color.cool
        case "passion":
            return Color.passion
        default:
            return Color.allType
        }
    }
    var charType: CGSSCharTypes {
        return CGSSCharTypes.init(typeString: type)
    }
    var charAgeType: CGSSCharAgeTypes {
        return CGSSCharAgeTypes.init(age: age)
    }
    var charBloodType: CGSSCharBloodTypes {
        return CGSSCharBloodTypes.init(bloodType: bloodType)
    }
    var charCVType: CGSSCharCVTypes {
        return voice == "" ? .no : .yes
    }
    var favoriteType: CGSSFavoriteTypes {
        return CGSSFavoriteManager.defaultManager.containsChar(self.charaId) ? .inFavorite : .notInFavorite
    }
    
    // 用于排序的动态属性
    dynamic var sHeight: Int {
        return height
    }
    dynamic var sWeight: Int {
        return weight
    }
    dynamic var BMI: Float {
        let fw = Float(weight)
        let fh = Float(height) / 100
        return fw / fh / fh
    }
    dynamic var sAge: Int {
        return age
    }
    dynamic var sizeB: Int {
        return bodySize1 >= 5000 ? 0 : bodySize1
    }
    dynamic var sizeW: Int {
        return bodySize2 >= 5000 ? 0 : bodySize2
    }
    dynamic var sizeH: Int {
        return bodySize3 >= 5000 ? 0 : bodySize3
    }
    dynamic var sName: String {
        return nameKana
    }
    dynamic var sCharaId: Int {
        return charaId
    }
    
    dynamic var sBirthday: Int {
        return birthMonth * 100 + birthDay
    }
    
    // 一些属性的特殊转换
    var handToString: String {
        let semaphore = DispatchSemaphore.init(value: 0)
        var resultString = ""
        CGSSGameResource.shared.master.selectTextBy(category: 5, index: hand - 3000) { (result) in
            resultString = result
            semaphore.signal()
        }
        semaphore.wait()
        return resultString
    }
    
    var constellationToString: String {
        let semaphore = DispatchSemaphore.init(value: 0)
        var resultString = ""
        CGSSGameResource.shared.master.selectTextBy(category: 4, index: constellation - 1000) { (result) in
            resultString = result
            semaphore.signal()
        }
        semaphore.wait()
        return resultString
    }
    
    var bloodTypeToString: String {
        switch bloodType {
        case 2001: return "A"
        case 2002: return "B"
        case 2003: return "AB"
        case 2004: return "O"
        default: return NSLocalizedString("不明", comment: "通用, 通常不会出现, 为一些未知字符串预留")
        }
    }
    
    var weightToString: String {
        if weight > 5000 {
            var result = ""
            let semaphore = DispatchSemaphore.init(value: 0)
            CGSSGameResource.shared.master.selectTextBy(category: 6, index: weight - 5000, callback: { (text) in
                result = text
                semaphore.signal()
            })
            semaphore.wait()
            return result
        } else {
            return String(weight) + "kg"
        }
    }
    
    var homeTownToString:String {
        var result = ""
        let semaphore = DispatchSemaphore.init(value: 0)
        CGSSGameResource.shared.master.selectTextBy(category: 2, index: homeTown) { (text) in
            result = text
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }
    
    var threeSizeToString: String {
        return "\(getSizeString(bodySize1))/\(getSizeString(bodySize2))/\(getSizeString(bodySize3))"
    }
    
    func getSizeString(_ size: Int) -> String {
        if size - 5000 > 0 {
            var result = ""
            let semaphore = DispatchSemaphore.init(value: 0)
            CGSSGameResource.shared.master.selectTextBy(category: 6, index: size - 5000, callback: { (text) in
                result = text
                semaphore.signal()
            })
            semaphore.wait()
            return result
        } else {
            return String(size)
        }
    }
    
    var ageToString: String {
        if age - 5000 > 0  {
            var result = ""
            let semaphore = DispatchSemaphore.init(value: 0)
            CGSSGameResource.shared.master.selectTextBy(category: 6, index: age - 5000, callback: { (text) in
                result = text
                semaphore.signal()
            })
            semaphore.wait()
            return "\(result)\(NSLocalizedString("岁", comment: "角色年龄"))"
        } else {
            return "\(age!)\(NSLocalizedString("岁", comment: "角色年龄"))"
        }
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
        if json == JSON.null {
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
            valist.append(valistJson.stringValue as AnyObject)
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
        age = aDecoder.decodeObject(forKey: "age") as? Int
        birthDay = aDecoder.decodeObject(forKey: "birth_day") as? Int
        birthMonth = aDecoder.decodeObject(forKey: "birth_month") as? Int
        bloodType = aDecoder.decodeObject(forKey: "blood_type") as? Int
        bodySize1 = aDecoder.decodeObject(forKey: "body_size_1") as? Int
        bodySize2 = aDecoder.decodeObject(forKey: "body_size_2") as? Int
        bodySize3 = aDecoder.decodeObject(forKey: "body_size_3") as? Int
        charaId = aDecoder.decodeObject(forKey: "chara_id") as? Int
        constellation = aDecoder.decodeObject(forKey: "constellation") as? Int
        conventional = aDecoder.decodeObject(forKey: "conventional") as? String
        favorite = aDecoder.decodeObject(forKey: "favorite") as? String
        hand = aDecoder.decodeObject(forKey: "hand") as? Int
        height = aDecoder.decodeObject(forKey: "height") as? Int
        homeTown = aDecoder.decodeObject(forKey: "home_town") as? Int
        iconImageRef = aDecoder.decodeObject(forKey: "icon_image_ref") as? String
        kanaSpaced = aDecoder.decodeObject(forKey: "kana_spaced") as? String
        kanjiSpaced = aDecoder.decodeObject(forKey: "kanji_spaced") as? String
        modelBustId = aDecoder.decodeObject(forKey: "model_bust_id") as? Int
        modelHeightId = aDecoder.decodeObject(forKey: "model_height_id") as? Int
        modelSkinId = aDecoder.decodeObject(forKey: "model_skin_id") as? Int
        modelWeightId = aDecoder.decodeObject(forKey: "model_weight_id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        nameKana = aDecoder.decodeObject(forKey: "name_kana") as? String
        personality = aDecoder.decodeObject(forKey: "personality") as? Int
        spineSize = aDecoder.decodeObject(forKey: "spine_size") as? Int
        translated = aDecoder.decodeObject(forKey: "translated") as? String
        translatedCht = aDecoder.decodeObject(forKey: "translated_cht") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        valist = aDecoder.decodeObject(forKey: "valist") as? [AnyObject]
        voice = aDecoder.decodeObject(forKey: "voice") as? String
        weight = aDecoder.decodeObject(forKey: "weight") as? Int
    }
    
    /**
         * NSCoding required method.
         * Encodes mode properties into the decoder
         */
    override func encode(with aCoder: NSCoder)
    {
        super.encode(with: aCoder)
        if age != nil {
            aCoder.encode(age, forKey: "age")
        }
        if birthDay != nil {
            aCoder.encode(birthDay, forKey: "birth_day")
        }
        if birthMonth != nil {
            aCoder.encode(birthMonth, forKey: "birth_month")
        }
        if bloodType != nil {
            aCoder.encode(bloodType, forKey: "blood_type")
        }
        if bodySize1 != nil {
            aCoder.encode(bodySize1, forKey: "body_size_1")
        }
        if bodySize2 != nil {
            aCoder.encode(bodySize2, forKey: "body_size_2")
        }
        if bodySize3 != nil {
            aCoder.encode(bodySize3, forKey: "body_size_3")
        }
        if charaId != nil {
            aCoder.encode(charaId, forKey: "chara_id")
        }
        if constellation != nil {
            aCoder.encode(constellation, forKey: "constellation")
        }
        if conventional != nil {
            aCoder.encode(conventional, forKey: "conventional")
        }
        if favorite != nil {
            aCoder.encode(favorite, forKey: "favorite")
        }
        if hand != nil {
            aCoder.encode(hand, forKey: "hand")
        }
        if height != nil {
            aCoder.encode(height, forKey: "height")
        }
        if homeTown != nil {
            aCoder.encode(homeTown, forKey: "home_town")
        }
        if iconImageRef != nil {
            aCoder.encode(iconImageRef, forKey: "icon_image_ref")
        }
        if kanaSpaced != nil {
            aCoder.encode(kanaSpaced, forKey: "kana_spaced")
        }
        if kanjiSpaced != nil {
            aCoder.encode(kanjiSpaced, forKey: "kanji_spaced")
        }
        if modelBustId != nil {
            aCoder.encode(modelBustId, forKey: "model_bust_id")
        }
        if modelHeightId != nil {
            aCoder.encode(modelHeightId, forKey: "model_height_id")
        }
        if modelSkinId != nil {
            aCoder.encode(modelSkinId, forKey: "model_skin_id")
        }
        if modelWeightId != nil {
            aCoder.encode(modelWeightId, forKey: "model_weight_id")
        }
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
        if nameKana != nil {
            aCoder.encode(nameKana, forKey: "name_kana")
        }
        if personality != nil {
            aCoder.encode(personality, forKey: "personality")
        }
        if spineSize != nil {
            aCoder.encode(spineSize, forKey: "spine_size")
        }
        if translated != nil {
            aCoder.encode(translated, forKey: "translated")
        }
        if translatedCht != nil {
            aCoder.encode(translatedCht, forKey: "translated_cht")
        }
        if type != nil {
            aCoder.encode(type, forKey: "type")
        }
        if valist != nil {
            aCoder.encode(valist, forKey: "valist")
        }
        if voice != nil {
            aCoder.encode(voice, forKey: "voice")
        }
        if weight != nil {
            aCoder.encode(weight, forKey: "weight")
        }
        
    }
    
}
