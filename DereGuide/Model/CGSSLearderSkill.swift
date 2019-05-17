//
//  CGSSLearderSkill.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

private let leaderSkillTarget = [
    "cute": NSLocalizedString("所有Cute", comment: "队长技能描述"),
    "cool": NSLocalizedString("所有Cool", comment: "队长技能描述"),
    "passion": NSLocalizedString("所有Passion", comment: "队长技能描述"),
    "all": NSLocalizedString("所有", comment: "队长技能描述"),
    "1": NSLocalizedString("所有Cute", comment: "队长技能描述"),
    "2": NSLocalizedString("所有Cool", comment: "队长技能描述"),
    "3": NSLocalizedString("所有Passion", comment: "队长技能描述"),
    "4": NSLocalizedString("所有", comment: "队长技能描述")
]

private let leaderSkillParam = [
    "vocal": NSLocalizedString("Vocal表现值", comment: "队长技能描述"),
    "visual": NSLocalizedString("Visual表现值", comment: "队长技能描述"),
    "dance": NSLocalizedString("Dance表现值", comment: "队长技能描述"),
    "all": NSLocalizedString("所有表现值", comment: "队长技能描述"),
    "life": NSLocalizedString("生命", comment: "队长技能描述"),
    "skill_probability": NSLocalizedString("特技发动几率", comment: "队长技能描述"),
    "1": NSLocalizedString("Vocal表现值", comment: "队长技能描述"),
    "2": NSLocalizedString("Visual表现值", comment: "队长技能描述"),
    "3": NSLocalizedString("Dance表现值", comment: "队长技能描述"),
    "4": NSLocalizedString("所有表现值", comment: "队长技能描述"),
    "5": NSLocalizedString("生命", comment: "队长技能描述"),
    "6": NSLocalizedString("特技发动几率", comment: "队长技能描述"),
]

fileprivate let effectClause = NSLocalizedString("提升%@偶像的%@ %d%%。", comment: "")
fileprivate let andConjunction = NSLocalizedString("%@和%@", comment: "")
fileprivate let andMark = NSLocalizedString("、", comment: "")
fileprivate let only = NSLocalizedString("只有%@", comment: "")

extension String {
    func firstCharacterUppercased() -> String {
        return String(self[startIndex]).uppercased() + self[index(after: startIndex)..<endIndex]
    }
}

extension CGSSLeaderSkill {
    
    private func buildPredicateClause() -> String {
        var needList: [String] = []
        var needSum = 0
        if needCute > 0 {
            needList.append(NSLocalizedString("Cute", comment: ""))
            needSum += needCute
        }
        if needCool > 0 {
            needList.append(NSLocalizedString("Cool", comment: ""))
            needSum += needCool
        }
        if needPassion > 0 {
            needList.append(NSLocalizedString("Passion", comment: ""))
            needSum += needPassion
        }
        
        var needStr = ""
        if needList.count > 0 {
            if needList.count == 1 {
                needStr = needList[0]
            } else if needList.count == 2 {
                needStr = needList.joined(separator: andMark)
            } else {
                needStr = needList[..<(needList.count - 1)].joined(separator: andMark)
                needStr = String.init(format: andConjunction, needStr, needList.last!)
            }
            
            if needList.count < 3 && needSum >= 5 {
                needStr = String.init(format: only, needStr)
            }
            
            let predicateClause = String.init(format: NSLocalizedString("当%@属性的偶像存在于队伍时，", comment: ""), needStr)
            return predicateClause
        }
        return ""
    }
   
    var localizedExplain: String {
        if upType == 1 && type == 20 {
            let attr = leaderSkillTarget[targetAttribute] ?? NSLocalizedString("未知", comment: "")
            let param = leaderSkillParam[targetParam] ?? NSLocalizedString("未知", comment: "")
            
            let effect = String(format: effectClause, attr, param, upValue)
            
            let built = buildPredicateClause() + effect
            
            return built.firstCharacterUppercased()
            
        } else if upType == 1 && type == 30 {
            let built = buildPredicateClause() + NSLocalizedString("完成LIVE时，额外获得特别奖励", comment: "")
            return built.firstCharacterUppercased()
        } else if upType == 1 && type == 40 {
            let effect = String(format: NSLocalizedString("完成LIVE时，获得的粉丝数提高 %d%%", comment: ""), upValue)
            let built = buildPredicateClause() + effect
            return built.firstCharacterUppercased()
        } else if upType == 1 && type == 50 {
            let format = NSLocalizedString("提升%@偶像的%@ %d%%、%@偶像的%@ %d%%。", comment: "")
            let attr = leaderSkillTarget[targetAttribute] ?? NSLocalizedString("未知", comment: "")
            let param = leaderSkillParam[targetParam] ?? NSLocalizedString("未知", comment: "")
            let attr2 = leaderSkillTarget[targetAttribute2] ?? NSLocalizedString("未知", comment: "")
            let param2 = leaderSkillParam[targetParam2] ?? NSLocalizedString("未知", comment: "")
            let effect = String(format: format, attr, param, upValue, attr2, param2, upValue2)
            let built = buildPredicateClause() + effect
            return built.firstCharacterUppercased()
        } else {
            // use in-game description
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
    var targetAttribute2: String!
    var targetParam2: String!
    var type: Int!
    var upType: Int!
    var upValue: Int!
    var upValue2: Int!
    
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
        targetParam2 = json["target_param_2"].stringValue
        targetAttribute2 = json["target_attribute_2"].stringValue
        upValue2 = json["up_value_2"].intValue
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
        targetParam2 = aDecoder.decodeObject(forKey: "target_param_2") as? String ?? ""
        targetAttribute2 = aDecoder.decodeObject(forKey: "target_attribute_2") as? String ?? ""
        upValue2 = aDecoder.decodeObject(forKey: "up_value_2") as? Int ?? 0
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
        if targetAttribute2 != nil {
            aCoder.encode(targetAttribute2, forKey: "target_attribute_2")
        }
        if targetParam2 != nil {
            aCoder.encode(targetParam2, forKey: "target_param_2")
        }
        if upValue2 != nil {
            aCoder.encode(upValue2, forKey: "up_value_2")
        }
    }
    
}
