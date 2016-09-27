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
    
    var skillFilterType: CGSSSkillTypes {
        return CGSSSkillTypes.init(typeString: skillType)
    }
    
    // 在计算触发几率和持续时间时 要在取每等级增量部分进行一次向下取整
    func procChanceOfLevel(_ lv: Int) -> Float? {
        if let p = procChance {
            let p1 = Float(p[1])
            let p0 = Float(p[0])
            return (floor((p1 - p0) / 9) * (Float(lv) - 1) + p0) / 100
        }
        return nil
    }
    func effectLengthOfLevel(_ lv: Int) -> Float? {
        if let e = effectLength {
            let e1 = Float(e[1])
            let e0 = Float(e[0])
            return (floor((e1 - e0) / 9) * (Float(lv) - 1) + e0) / 100
        }
        return nil
    }
    func getExplainByLevel(_ lv: Int, languageType: LanguageType = .ja) -> String {
        var explain:String
        switch languageType {
        case .zh:
            explain = explainEn
        case .ja:
            return self.explain
        default:
            return self.explain
        }
        let pattern = "[0-9.]+ ~ [0-9.]+"
        let subs = CGSSGlobal.getStringByPattern(str: explain, pattern: pattern)
        let sub1 = subs[0]
        let range1 = explain.range(of: sub1 as String)
        explain.replaceSubrange(range1!, with: String(format: "%.2f", self.procChanceOfLevel(lv)!))
        let sub2 = subs[1]
        let range2 = explain.range(of: sub2 as String)
        explain.replaceSubrange(range2!, with: String(format: "%.2f", self.effectLengthOfLevel(lv)!))
        return explain
    }
    func getExplainByLevelRange(_ start: Int, end: Int, languageType: LanguageType = .ja) -> String {
        var explain:String
        switch languageType {
        case .zh:
            explain = explainEn
        case .ja:
            return self.explain
        default:
            return self.explain
        }
        let pattern = "[0-9.]+ ~ [0-9.]+"
        let subs = CGSSGlobal.getStringByPattern(str: explain, pattern: pattern)
        let sub1 = subs[0]
        let range1 = explain.range(of: sub1 as String)
        explain.replaceSubrange(range1!, with: String(format: "%.2f ~ %.2f", self.procChanceOfLevel(start)!, self.procChanceOfLevel(end)!))
        let sub2 = subs[1]
        let range2 = explain.range(of: sub2 as String)
        explain.replaceSubrange(range2!, with: String(format: "%.2f ~ %.2f", self.effectLengthOfLevel(start)!, self.effectLengthOfLevel(end)!))
        return explain
    }
    
    var procTypeShort: String {
        switch maxChance {
        case 6000:
            return NSLocalizedString("高", comment: "技能触发几率的简写")
        case 5250:
            return NSLocalizedString("中", comment: "技能触发几率的简写")
        case 4500:
            return NSLocalizedString("低", comment: "技能触发几率的简写")
        default:
            return NSLocalizedString("其他", comment: "通用, 通常不会出现, 为未知字符预留")
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
        condition = aDecoder.decodeObject(forKey: "condition") as? Int
        cutinType = aDecoder.decodeObject(forKey: "cutin_type") as? Int
        effectLength = aDecoder.decodeObject(forKey: "effect_length") as? [Int]
        explain = aDecoder.decodeObject(forKey: "explain") as? String
        explainEn = aDecoder.decodeObject(forKey: "explain_en") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        judgeType = aDecoder.decodeObject(forKey: "judge_type") as? Int
        maxChance = aDecoder.decodeObject(forKey: "max_chance") as? Int
        maxDuration = aDecoder.decodeObject(forKey: "max_duration") as? Int
        procChance = aDecoder.decodeObject(forKey: "proc_chance") as? [Int]
        skillName = aDecoder.decodeObject(forKey: "skill_name") as? String
        skillTriggerType = aDecoder.decodeObject(forKey: "skill_trigger_type") as? Int
        skillTriggerValue = aDecoder.decodeObject(forKey: "skill_trigger_value") as? Int
        skillType = aDecoder.decodeObject(forKey: "skill_type") as? String
        value = aDecoder.decodeObject(forKey: "value") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    override func encode(with aCoder: NSCoder)
    {
        super.encode(with: aCoder)
        if condition != nil {
            aCoder.encode(condition, forKey: "condition")
        }
        if cutinType != nil {
            aCoder.encode(cutinType, forKey: "cutin_type")
        }
        if effectLength != nil {
            aCoder.encode(effectLength, forKey: "effect_length")
        }
        if explain != nil {
            aCoder.encode(explain, forKey: "explain")
        }
        if explainEn != nil {
            aCoder.encode(explainEn, forKey: "explain_en")
        }
        if id != nil {
            aCoder.encode(id, forKey: "id")
        }
        if judgeType != nil {
            aCoder.encode(judgeType, forKey: "judge_type")
        }
        if maxChance != nil {
            aCoder.encode(maxChance, forKey: "max_chance")
        }
        if maxDuration != nil {
            aCoder.encode(maxDuration, forKey: "max_duration")
        }
        if procChance != nil {
            aCoder.encode(procChance, forKey: "proc_chance")
        }
        if skillName != nil {
            aCoder.encode(skillName, forKey: "skill_name")
        }
        if skillTriggerType != nil {
            aCoder.encode(skillTriggerType, forKey: "skill_trigger_type")
        }
        if skillTriggerValue != nil {
            aCoder.encode(skillTriggerValue, forKey: "skill_trigger_value")
        }
        if skillType != nil {
            aCoder.encode(skillType, forKey: "skill_type")
        }
        if value != nil {
            aCoder.encode(value, forKey: "value")
        }
        
    }
    
}
