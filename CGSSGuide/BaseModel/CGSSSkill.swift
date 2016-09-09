//
//  CGSSSkill.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

extension CGSSSkill {
    
    var skillFilterType: CGSSSkillFilterType {
        return CGSSSkillFilterType.init(type: skillType)
    }
    
    func procChanceOfLevel(lv: Int) -> Float? {
        if let p = procChance {
            let p1 = Float(p[1])
            let p0 = Float(p[0])
            return ((p1 - p0) / 9 * (Float(lv) - 1) + p0) / 100
        }
        return nil
    }
    func effectLengthOfLevel(lv: Int) -> Float? {
        if let e = effectLength {
            let e1 = Float(e[1])
            let e0 = Float(e[0])
            return ((e1 - e0) / 9 * (Float(lv) - 1) + e0) / 100
        }
        return nil
    }
    func getExplainByLevel(lv: Int) -> String {
        var explain = explainEn ?? ""
        let pattern = "[0-9.]+ ~ [0-9.]+"
        let subs = CGSSGlobal.getStringByPattern(explain, pattern: pattern)
        let sub1 = subs[0]
        let range1 = explain.rangeOfString(sub1 as String)
        explain.replaceRange(range1!, with: String(format: "%.2f", self.procChanceOfLevel(lv)!))
        let sub2 = subs[1]
        let range2 = explain.rangeOfString(sub2 as String)
        explain.replaceRange(range2!, with: String(format: "%.2f", self.effectLengthOfLevel(lv)!))
        return explain
    }
    
    var procTypeShort: String {
        switch maxChance {
        case 6000:
            return "高"
        case 5250:
            return "中"
        case 4500:
            return "低"
        default:
            return "其他"
        }
    }
    
}

class CGSSSkill: CGSSBaseModel {
    
    var condition: Int!
    var cutinType: Int!
    var effectLength: [Int]!
    var explain: String!
    var explainEn: String!
    var id: Int!
    var judgeType: Int!
    var maxChance: Int!
    var maxDuration: Int!
    var procChance: [Int]!
    var skillName: String!
    var skillTriggerType: Int!
    var skillTriggerValue: Int!
    var skillType: String!
    var value: Int!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        super.init()
        if json == nil {
            return
        }
        condition = json["condition"].intValue
        cutinType = json["cutin_type"].intValue
        effectLength = [Int]()
        let effectLengthArray = json["effect_length"].arrayValue
        for effectLengthJson in effectLengthArray {
            effectLength.append(effectLengthJson.intValue)
        }
        explain = json["explain"].stringValue
        explainEn = json["explain_en"].stringValue
        id = json["id"].intValue
        judgeType = json["judge_type"].intValue
        maxChance = json["max_chance"].intValue
        maxDuration = json["max_duration"].intValue
        procChance = [Int]()
        let procChanceArray = json["proc_chance"].arrayValue
        for procChanceJson in procChanceArray {
            procChance.append(procChanceJson.intValue)
        }
        skillName = json["skill_name"].stringValue
        skillTriggerType = json["skill_trigger_type"].intValue
        skillTriggerValue = json["skill_trigger_value"].intValue
        skillType = json["skill_type"].stringValue
        value = json["value"].intValue
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        condition = aDecoder.decodeObjectForKey("condition") as? Int
        cutinType = aDecoder.decodeObjectForKey("cutin_type") as? Int
        effectLength = aDecoder.decodeObjectForKey("effect_length") as? [Int]
        explain = aDecoder.decodeObjectForKey("explain") as? String
        explainEn = aDecoder.decodeObjectForKey("explain_en") as? String
        id = aDecoder.decodeObjectForKey("id") as? Int
        judgeType = aDecoder.decodeObjectForKey("judge_type") as? Int
        maxChance = aDecoder.decodeObjectForKey("max_chance") as? Int
        maxDuration = aDecoder.decodeObjectForKey("max_duration") as? Int
        procChance = aDecoder.decodeObjectForKey("proc_chance") as? [Int]
        skillName = aDecoder.decodeObjectForKey("skill_name") as? String
        skillTriggerType = aDecoder.decodeObjectForKey("skill_trigger_type") as? Int
        skillTriggerValue = aDecoder.decodeObjectForKey("skill_trigger_value") as? Int
        skillType = aDecoder.decodeObjectForKey("skill_type") as? String
        value = aDecoder.decodeObjectForKey("value") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    override func encodeWithCoder(aCoder: NSCoder)
    {
        super.encodeWithCoder(aCoder)
        if condition != nil {
            aCoder.encodeObject(condition, forKey: "condition")
        }
        if cutinType != nil {
            aCoder.encodeObject(cutinType, forKey: "cutin_type")
        }
        if effectLength != nil {
            aCoder.encodeObject(effectLength, forKey: "effect_length")
        }
        if explain != nil {
            aCoder.encodeObject(explain, forKey: "explain")
        }
        if explainEn != nil {
            aCoder.encodeObject(explainEn, forKey: "explain_en")
        }
        if id != nil {
            aCoder.encodeObject(id, forKey: "id")
        }
        if judgeType != nil {
            aCoder.encodeObject(judgeType, forKey: "judge_type")
        }
        if maxChance != nil {
            aCoder.encodeObject(maxChance, forKey: "max_chance")
        }
        if maxDuration != nil {
            aCoder.encodeObject(maxDuration, forKey: "max_duration")
        }
        if procChance != nil {
            aCoder.encodeObject(procChance, forKey: "proc_chance")
        }
        if skillName != nil {
            aCoder.encodeObject(skillName, forKey: "skill_name")
        }
        if skillTriggerType != nil {
            aCoder.encodeObject(skillTriggerType, forKey: "skill_trigger_type")
        }
        if skillTriggerValue != nil {
            aCoder.encodeObject(skillTriggerValue, forKey: "skill_trigger_value")
        }
        if skillType != nil {
            aCoder.encodeObject(skillType, forKey: "skill_type")
        }
        if value != nil {
            aCoder.encodeObject(value, forKey: "value")
        }
        
    }
    
}
