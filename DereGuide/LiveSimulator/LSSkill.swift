//
//  LSSkill.swift
//  DereGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

enum LSSkillType {
    case comboBonus
    case perfectBonus
    case skillBoost
    case heal
    case overload
    case deep
    case allRound
    
    case concentration
    
    case `guard`
    case comboContinue
    case perfectLock
    
    case encore
    
    case lifeSparkle
    
    static let allPerfectBonus: [LSSkillType] = [LSSkillType.perfectBonus, .overload, .deep, .concentration]
    static let allComboBonus: [LSSkillType] = [LSSkillType.allRound, .comboBonus, .deep]
    static let allLifeResotre: [LSSkillType] = [LSSkillType.allRound, .heal]
    
    init?(type: CGSSSkillTypes) {
        switch type {
        case CGSSSkillTypes.comboBonus:
            self = .comboBonus
        case CGSSSkillTypes.allRound:
            self = .allRound
        case CGSSSkillTypes.perfectBonus:
            self = .perfectBonus
        case CGSSSkillTypes.concentration:
            self = .concentration
        case  CGSSSkillTypes.overload:
            self = .overload
        case CGSSSkillTypes.deep:
            self = .deep
        case CGSSSkillTypes.boost:
            self = .skillBoost
        case CGSSSkillTypes.heal:
            self = .heal
        case CGSSSkillTypes.comboContinue:
            self = .comboContinue
        case CGSSSkillTypes.perfectLock:
            self = .perfectLock
        case CGSSSkillTypes.guard:
            self = .guard
        case CGSSSkillTypes.encore:
            self = .encore
        case CGSSSkillTypes.lifeSparkle:
            self = .lifeSparkle
        default:
            return nil
        }
    }
}

struct LSSkill {
    
    var range: LSRange<Float>
    
    /// in percent, 117 means 17%up
    var value: Int
    
    /// heal of all round / combo bonus of deep
    var value2: Int
    
    var type: LSSkillType
    
    /// 0 ~ 10000
    var rate: Double
    
    /// in percent, 30 means 0.3
    var rateBonus: Int
    
    /// overload skills' trigger life value
    var triggerLife: Int
    
    /// 0 ~ 4, the index of the member in the unit
    var position: Int
}

extension LSSkill {
    
    var probability: Double {
        return min(1, rate * Double(100 + rateBonus) / 1000000)
    }
    
    var isConcentrated: Bool {
        return type == .concentration
    }
    
}

extension LSSkill {
    
    var comboBonusValue: Int {
        if type == .deep {
            return value2
        } else if LSSkillType.allComboBonus.contains(type) {
            return value
        } else {
            return 0
        }
    }
    
    var lifeValue: Int {
        if type == .allRound {
            return value2
        } else if LSSkillType.allLifeResotre.contains(type) {
            return value
        } else {
            return 0
        }
    }
}
