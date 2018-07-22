//
//  CGSSSkill.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

fileprivate let skillDescriptions = [
    1: NSLocalizedString("使所有PERFECT音符获得 %d%% 的分数加成", comment: "技能描述"),
    2: NSLocalizedString("使所有PERFECT/GREAT音符获得 %d%% 的分数加成", comment: "技能描述"),
    3: NSLocalizedString("使所有PERFECT/GREAT/NICE音符获得 %d%% 的分数加成", comment: "技能描述"),
    4: NSLocalizedString("获得额外的 %d%% 的COMBO加成", comment: "技能描述"),
    5: NSLocalizedString("使所有GREAT音符改判为PERFECT", comment: "技能描述"),
    6: NSLocalizedString("使所有GREAT/NICE音符改判为PERFECT", comment: "技能描述"),
    7: NSLocalizedString("使所有GREAT/NICE/BAD音符改判为PERFECT", comment: "技能描述"),
    8: NSLocalizedString("所有音符改判为PERFECT", comment: "技能描述"),
    9: NSLocalizedString("使NICE音符不会中断COMBO", comment: "技能描述"),
    10: NSLocalizedString("使BAD/NICE音符不会中断COMBO", comment: "技能描述"),
    11: NSLocalizedString("使你的COMBO不会中断", comment: "技能描述"),
    12: NSLocalizedString("使你的生命不会减少", comment: "技能描述"),
    13: NSLocalizedString("使所有音符恢复你 %d 点生命", comment: "技能描述"),
    14: NSLocalizedString("消耗 %2$d 生命，PERFECT音符获得 %1$d%% 的分数加成，并且NICE/BAD音符不会中断COMBO", comment: "技能描述"),
    15: NSLocalizedString("使所有PERFECT音符获得 %d%% 的分数加成，且使PERFECT判定区间的时间范围缩小", comment: ""),
    16: NSLocalizedString("重复发动上一个其他偶像发动过的技能", comment: ""),
    17: NSLocalizedString("使所有PERFECT音符恢复你 %d 点生命", comment: "技能描述"),
    18: NSLocalizedString("使所有PERFECT/GREAT音符恢复你 %d 点生命", comment: "技能描述"),
    19: NSLocalizedString("使所有PERFECT/GREAT/NICE音符恢复你 %d 点生命", comment: "技能描述"),
    20: NSLocalizedString("使当前发动的分数加成和COMBO加成额外提高 %d%%，生命恢复和护盾额外恢复 1 点生命，改判范围增加一档", comment: ""),
    21: NSLocalizedString("当仅有Cute偶像存在于队伍时，使所有PERFECT音符获得 %d%% 的分数加成，并获得额外的 %d%% 的COMBO加成", comment: ""),
    22: NSLocalizedString("当仅有Cool偶像存在于队伍时，使所有PERFECT音符获得 %d%% 的分数加成，并获得额外的 %d%% 的COMBO加成", comment: ""),
    23: NSLocalizedString("当仅有Passion偶像存在于队伍时，使所有PERFECT音符获得 %d%% 的分数加成，并获得额外的 %d%% 的COMBO加成", comment: ""),
    24: NSLocalizedString("获得额外的 %d%% 的COMBO加成，并使所有PERFECT音符恢复你 %d 点生命", comment: ""),
    25: NSLocalizedString("获得额外的COMBO加成，当前生命值越高加成越高", comment: ""),
    26: NSLocalizedString("当Cute、Cool和Passion偶像存在于队伍时，使所有PERFECT音符获得 %1$d%% 的分数加成/恢复你 %3$d 点生命，并获得额外的 %2$d%% 的COMBO加成", comment: "")
]

fileprivate let intervalClause = NSLocalizedString("每 %d 秒，", comment: "")

fileprivate let probabilityClause = NSLocalizedString("有 %@%% 的几率", comment: "")

fileprivate let lengthClause = NSLocalizedString("，持续 %@ 秒。", comment: "")

extension CGSSSkill {
    
    private var effectValue: Int {
        var effectValue = value!
        if [1, 2, 3, 4, 14, 15, 21, 22, 23, 24, 26].contains(skillTypeId) {
            effectValue -= 100
        } else if [20].contains(skillTypeId) {
            // there is only one possibility: 20% up for combo bonus and perfect bonus, using fixed value here instead of reading it from database table skill_boost_type. if more possiblities are added to the game, fix here.
            effectValue = 20
        }
        return effectValue
    }
    
    private var effectValue2: Int {
        var effectValue2 = value2!
        if [21, 22, 23, 26].contains(skillTypeId) {
            effectValue2  -= 100
        }
        return effectValue2
    }
    
    private var effectValue3: Int {
        return value3
    }
    
    private var effectExpalin: String {
        if skillTypeId == 14 {
            return String.init(format: skillDescriptions[skillTypeId] ?? NSLocalizedString("未知", comment: ""), effectValue, skillTriggerValue)
        } else {
            return String.init(format: skillDescriptions[skillTypeId] ?? NSLocalizedString("未知", comment: ""), effectValue, effectValue2, effectValue3)
        }
    }
    
    private var intervalExplain: String {
        return String.init(format: intervalClause, condition)
    }
    
    @nonobjc func getLocalizedExplainByRange(_ range: CountableClosedRange<Int>) -> String {
        
        let probabilityRangeString = String(format: "%.2f ~ %.2f", Double(procChanceOfLevel(range.lowerBound)) / 100, Double(procChanceOfLevel(range.upperBound)) / 100)
        let probabilityExplain = String.init(format: probabilityClause, probabilityRangeString)
        
        let lengthRangeString = String(format: "%.2f ~ %.2f", Double(effectLengthOfLevel(range.lowerBound)) / 100, Double(effectLengthOfLevel(range.upperBound)) / 100)
        let lengthExplain = String(format: lengthClause, lengthRangeString)
        
        return intervalExplain + probabilityExplain + effectExpalin + lengthExplain
    }
    
    @nonobjc func getLocalizedExplainByLevel(_ level: Int) -> String {
      
        let probabilityRangeString = String(format: "%@", (Decimal(procChanceOfLevel(level)) / 100).description)
        let probabilityExplain = String.init(format: probabilityClause, probabilityRangeString)
        
        let lengthRangeString = String(format: "%@", (Decimal(effectLengthOfLevel(level)) / 100).description)
        let lengthExplain = String.init(format: lengthClause, lengthRangeString)
        
        return intervalExplain + probabilityExplain + effectExpalin + lengthExplain
    }
    
    var skillFilterType: CGSSSkillTypes {
        return CGSSSkillTypes(typeID: skillTypeId)
    }
    
    var descriptionShort: String {
        return "\(condition!)s/\(procTypeShort)/\(skillFilterType.description)"
    }
    
    // 在计算触发几率和持续时间时 要在取每等级增量部分进行一次向下取整
    func procChanceOfLevel(_ lv: Int) -> Int {
        if let p = procChance {
            let p1 = Float(p[1])
            let p0 = Float(p[0])
            return wpcap(x :(p1 - p0) / 9 * Float(lv - 1) + p0)
        } else {
            return 0
        }
    }
    
    func wpcap(x: Float) -> Int {
        var n = Int(x)
        let n10 = Int(x * 10)
        if (n10 % 10 != 0) {
            n += 1
        }
        return n
    }
    
    func effectLengthOfLevel(_ lv: Int) -> Int {
        if let e = effectLength {
            let e1 = Float(e[1])
            let e0 = Float(e[0])
            
            return wpcap(x: (e1 - e0) / 9 * Float(lv - 1) + e0)
        } else {
            return 0
        }
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
    var value3: Int!
    
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
        value3 = json["value_3"].intValue
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
        value3 = aDecoder.decodeObject(forKey: "value_3") as? Int
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
        if value3 != nil {
            aCoder.encode(value3, forKey: "value_3")
        }
    }
    
}
