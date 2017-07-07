//
//  CGSSLearderSkill.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

fileprivate let leaderSkillTarget:[Int:String] = [
    1: NSLocalizedString("所有Cute", comment: "队长技能描述"),
    2: NSLocalizedString("所有Cool", comment: "队长技能描述"),
    3: NSLocalizedString("所有Passion", comment: "队长技能描述"),
    4: NSLocalizedString("所有", comment: "队长技能描述")
]

fileprivate let leaderSkillParam = [
    1: NSLocalizedString("Vocal表现值", comment: "队长技能描述"),
    2: NSLocalizedString("Visual表现值", comment: "队长技能描述"),
    3: NSLocalizedString("Dance表现值", comment: "队长技能描述"),
    4: NSLocalizedString("所有表现值", comment: "队长技能描述"),
    5: NSLocalizedString("生命", comment: "队长技能描述"),
    6: NSLocalizedString("特技发动几率", comment: "队长技能描述")
]

extension CGSSLeaderSkill {
    func getLocalizedExplain(languageType: LanguageType) -> String {
        switch languageType {
        case .zh:
            return explainEn
        default:
            return explain
        }
    }
}

class CGSSLeaderSkill: CGSSBaseModel {
    
    var explain: String!
    var explainEn: String!
    var id: Int!
    var name: String!
    var needCool: Int!
    var needCute: Int!
    var needPassion: Int!
    var specialId: Int!
    var targetAttribute: String!
    var targetParam: String!
    var type: Int!
    var upType: Int!
    var upValue: Int!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        super.init()
        if json == JSON.null {
            return
        }
        explain = json["explain"].stringValue
        explainEn = json["explain_en"].stringValue
        id = json["id"].intValue
        name = json["name"].stringValue
        needCool = json["need_cool"].intValue
        needCute = json["need_cute"].intValue
        needPassion = json["need_passion"].intValue
        specialId = json["special_id"].intValue
        targetAttribute = json["target_attribute"].stringValue
        targetParam = json["target_param"].stringValue
        type = json["type"].intValue
        upType = json["up_type"].intValue
        upValue = json["up_value"].intValue
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        explain = aDecoder.decodeObject(forKey: "explain") as? String
        explainEn = aDecoder.decodeObject(forKey: "explain_en") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        needCool = aDecoder.decodeObject(forKey: "need_cool") as? Int
        needCute = aDecoder.decodeObject(forKey: "need_cute") as? Int
        needPassion = aDecoder.decodeObject(forKey: "need_passion") as? Int
        specialId = aDecoder.decodeObject(forKey: "special_id") as? Int
        targetAttribute = aDecoder.decodeObject(forKey: "target_attribute") as? String
        targetParam = aDecoder.decodeObject(forKey: "target_param") as? String
        type = aDecoder.decodeObject(forKey: "type") as? Int
        upType = aDecoder.decodeObject(forKey: "up_type") as? Int
        upValue = aDecoder.decodeObject(forKey: "up_value") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    override func encode(with aCoder: NSCoder)
    {
        super.encode(with: aCoder)
        if explain != nil {
            aCoder.encode(explain, forKey: "explain")
        }
        if explainEn != nil {
            aCoder.encode(explainEn, forKey: "explain_en")
        }
        if id != nil {
            aCoder.encode(id, forKey: "id")
        }
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
        if needCool != nil {
            aCoder.encode(needCool, forKey: "need_cool")
        }
        if needCute != nil {
            aCoder.encode(needCute, forKey: "need_cute")
        }
        if needPassion != nil {
            aCoder.encode(needPassion, forKey: "need_passion")
        }
        if specialId != nil {
            aCoder.encode(specialId, forKey: "special_id")
        }
        if targetAttribute != nil {
            aCoder.encode(targetAttribute, forKey: "target_attribute")
        }
        if targetParam != nil {
            aCoder.encode(targetParam, forKey: "target_param")
        }
        if type != nil {
            aCoder.encode(type, forKey: "type")
        }
        if upType != nil {
            aCoder.encode(upType, forKey: "up_type")
        }
        if upValue != nil {
            aCoder.encode(upValue, forKey: "up_value")
        }
        
    }
    
}
