//
//  CGSSSkill.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

fileprivate let skillDescriptions = [
    1: NSLocalizedString("使所有PERFECT音符获得 %d 的分数加成", comment: "技能描述"),
    2: NSLocalizedString("使所有PERFECT/GREAT音符获得 d% 的分数加成", comment: "技能描述"),
    3: NSLocalizedString("使所有PERFECT/GREAT/NICE音符获得 d% 的分数加成", comment: "技能描述"),
    4: NSLocalizedString("获得额外的 d% 的COMBO加成", comment: "技能描述"),
    5: NSLocalizedString("使所有GREAT音符改判为PERFECT", comment: "技能描述"),
    6: NSLocalizedString("使所有GREAT/NICE音符改判为PERFECT", comment: "技能描述"),
    7: NSLocalizedString("使所有GREAT/NICE/BAD音符改判为PERFECT", comment: "技能描述"),
    8: NSLocalizedString("所有音符改判为PERFECT", comment: "技能描述"),
    9: NSLocalizedString("使NICE音符不会中断COMBO", comment: "技能描述"),
    10: NSLocalizedString("使BAD/NICE音符不会中断COMBO", comment: "技能描述"),
    11: NSLocalizedString("使你的COMBO不会中断", comment: "技能描述"),
    12: NSLocalizedString("使你的生命不会减少", comment: "技能描述"),
    13: NSLocalizedString("使所有音符恢复你 %d 点生命", comment: "技能描述"),
    14: NSLocalizedString("消耗 %d 生命，PERFECT音符获得 d% 的分数加成，并且NICE/BAD音符不会中断COMBO", comment: "技能描述"),
    17: NSLocalizedString("使所有PERFECT音符恢复你 d% 点生命", comment: "技能描述"),
    18: NSLocalizedString("使所有PERFECT/GREAT音符恢复你 d% 点生命", comment: "技能描述"),
    19: NSLocalizedString("使所有PERFECT/GREAT/NICE音符恢复你 %d 点生命", comment: "技能描述")
]


extension CGSSSkill {
    
    var skillFilterType: CGSSSkillTypes {
        return CGSSSkillTypes.init(typeId: skillTypeId)
    }
    
    var descriptionShort: String {
        return "\(condition!)s/\(procTypeShort)/\(skillFilterType.description)"
    }
    
    // 在计算触发几率和持续时间时 要在取每等级增量部分进行一次向下取整
    func procChanceOfLevel(_ lv: Int) -> Double {
        if let p = procChance {
            let p1 = Double(p[1])
            let p0 = Double(p[0])
            return (floor((p1 - p0) / 9) * (Double(lv) - 1) + p0)
        } else {
            return 0
        }
    }
    
    func effectLengthOfLevel(_ lv: Int) -> Double {
        if let e = effectLength {
            let e1 = Double(e[1])
            let e0 = Double(e[0])
            return (floor((e1 - e0) / 9) * (Double(lv) - 1) + e0)
        } else {
            return 0
        }
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
        let subs = explain.match(pattern: "[0-9.]+ ~ [0-9.]+")
        let sub1 = subs[0]
        let range1 = explain.range(of: sub1 as String)
        explain.replaceSubrange(range1!, with: String(format: "%.2f", self.procChanceOfLevel(lv) / 100))
        let sub2 = subs[1]
        let range2 = explain.range(of: sub2 as String)
        explain.replaceSubrange(range2!, with: String(format: "%.2f", self.effectLengthOfLevel(lv) / 100))
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
        let subs = explain.match(pattern: "[0-9.]+ ~ [0-9.]+")
        let sub1 = subs[0]
        let range1 = explain.range(of: sub1 as String)
        explain.replaceSubrange(range1!, with: String(format: "%.2f ~ %.2f", self.procChanceOfLevel(start) / 100, self.procChanceOfLevel(end) / 100))
        let sub2 = subs[1]
        let range2 = explain.range(of: sub2 as String)
        explain.replaceSubrange(range2!, with: String(format: "%.2f ~ %.2f", self.effectLengthOfLevel(start) / 100, self.effectLengthOfLevel(end) / 100))
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
    
    var procType: CGSSProcTypes {
        switch maxChance {
        case 6000:
            return .high
        case 5250:
            return .middle
        case 4500:
            return .low
        default:
            return .none
        }
    }
    
    var conditionType: CGSSConditionTypes {
        switch condition {
        case 4:
            return .c4
        case 6:
            return .c6
        case 7:
            return .c7
        case 9:
            return .c9
        case 11:
            return .c11
        case 13:
            return .c13
        default:
            return .other
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
    var skillTypeId: Int!
    var value2: Int!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        super.init()
        if json == JSON.null {
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
        if skillType == "" {
            skillType = NSLocalizedString("未知", comment: "")
        }

        value = json["value"].intValue
        value2 = json["value_2"].intValue
        skillTypeId = json["skill_type_id"].intValue
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
        skillType = aDecoder.decodeObject(forKey: "skill_type") as? String ?? NSLocalizedString("未知", comment: "")
        value = aDecoder.decodeObject(forKey: "value") as? Int
        skillTypeId = aDecoder.decodeObject(forKey: "skill_type_id") as? Int
        value2 = aDecoder.decodeObject(forKey: "value_2") as? Int
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
        if skillTypeId != nil {
            aCoder.encode(skillTypeId, forKey: "skill_type_id")
        }
        if value2 != nil {
            aCoder.encode(value2, forKey: "value_2")
        }
    }
    
}
