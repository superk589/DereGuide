//
//  LSScoreBonus.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

enum LSScoreBonusType {
    case comboBonus
    case perfectBonus
    case skillBoost
    case heal
    case overload
    case deep
    case allRound
    
    case `guard`
    case comboContinue
    case perfectLock
    
    static let allSupport: [LSScoreBonusType] = [LSScoreBonusType.guard, .skillBoost, .overload, .heal, .allRound, .comboContinue, .perfectLock]
    static let allBonus: [LSScoreBonusType] = [LSScoreBonusType.comboBonus, .perfectBonus, .skillBoost, .heal, .overload, .deep, .allRound]
    static let allPerfectBonus: [LSScoreBonusType] = [LSScoreBonusType.perfectBonus, .overload, ]
    
    var isSupportSkills: Bool {
        return LSScoreBonusType.allSupport.contains(self)
    }
    
    var isBonusSkills: Bool {
        return LSScoreBonusType.allBonus.contains(self)
    }
        
    init?(type: CGSSSkillTypes) {
        switch type {
        case CGSSSkillTypes.comboBonus:
            self = .comboBonus
        case CGSSSkillTypes.allRound:
            self = .allRound
        case CGSSSkillTypes.perfectBonus, CGSSSkillTypes.concentration:
            self = .perfectBonus
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
        default:
            return nil
        }
    }
}

struct LSScoreBonus {
    
    var range: LSRange
    
    // In percent, 117 means 17%up
    var value: Int
    
    // heal of all round / combo bonus of deep 
    var value2: Int
    
    var type: LSScoreBonusType
    
    // In 0 - 10000
    var rate: Double
    
    // In percent, 30 means 0.3
    var rateBonus: Int
    
    var triggerLife: Int
    
    var probability: Double {
        return min(1, rate * Double(100 + rateBonus) / 1000000)
    }
    
}
