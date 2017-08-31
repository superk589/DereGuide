//
//  CGSSLearderSkill.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

fileprivate let leaderSkillTarget = [
    "cute": NSLocalizedString("所有Cute", comment: "队长技能描述"),
    "cool": NSLocalizedString("所有Cool", comment: "队长技能描述"),
    "passion": NSLocalizedString("所有Passion", comment: "队长技能描述"),
    "all": NSLocalizedString("所有", comment: "队长技能描述")
]

fileprivate let leaderSkillParam = [
    "vocal": NSLocalizedString("Vocal表现值", comment: "队长技能描述"),
    "visual": NSLocalizedString("Visual表现值", comment: "队长技能描述"),
    "dance": NSLocalizedString("Dance表现值", comment: "队长技能描述"),
    "all": NSLocalizedString("所有表现值", comment: "队长技能描述"),
    "life": NSLocalizedString("生命", comment: "队长技能描述"),
    "skill_probability": NSLocalizedString("特技发动几率", comment: "队长技能描述")
]

fileprivate var effectClause = NSLocalizedString("提升%@偶像的%@ %d%%。", comment: "")
fileprivate var andConjunction = NSLocalizedString("%@和%@", comment: "")
fileprivate var andMark = NSLocalizedString("、", comment: "")
fileprivate var only = NSLocalizedString("只有%@", comment: "")
fileprivate var predicateClause = NSLocalizedString("当%@属性的偶像存在于队伍时，", comment: "")
fileprivate var unknown = NSLocalizedString("此队长技能的内部描述格式未定义", comment: "")

extension CGSSLeaderSkill {
   
    var localizedExplain: String {
        if upType == 1 && type == 20 {
            let attr = leaderSkillTarget[targetAttribute] ?? NSLocalizedString("未知", comment: "")
            let param = leaderSkillParam[targetParam] ?? NSLocalizedString("未知", comment: "")
            
            let effect = String.init(format: effectClause, attr, param, upValue)
            
            var needList: [String] = []
            if needCute > 0 {
                needList.append(NSLocalizedString("Cute", comment: ""))
            }
            if needCool > 0 {
                needList.append(NSLocalizedString("Cool", comment: ""))
            }
            if needPassion > 0 {
                needList.append(NSLocalizedString("Passion", comment: ""))
            }
            
            var needStr = ""
            if needList.count > 0 {
                if needList.count == 1 {
                    needStr = needList[0]
                } else {
                    needStr = needList[..<(needList.count - 1)].joined(separator: andMark)
                    needStr = String.init(format: andConjunction, needStr, needList.last!)
                }
                
                // FIXME: consider values of need_x in leader_skill_t
                // Rei_Fan49 - Today at 5:36 PM
                // princess and focus only works for single color
                // it requires 5 or 6 per color
                // which implies monocolor unit or no activation
                // cinfest unit requires 1 each color (according to internal data)
                
                if needList.count < 3 {
                    needStr = String.init(format: only, needStr)
                }
                
                let built = String.init(format: predicateClause, needStr) + effect
                return built
            } else {
                // if there is not predicate clause, uppercase the first letter.
                let built = String(effect[effect.startIndex]).uppercased() + effect[effect.index(after: effect.startIndex)..<effect.endIndex]
                return built
            }
        } else {
            return unknown
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
