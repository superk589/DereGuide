//
//  LSScoreBonus.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct LSScoreBonusTypes: OptionSet, Hashable {
    let rawValue:UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let comboBonus = LSScoreBonusTypes.init(rawValue: 1 << 0)
    static let perfectBonus = LSScoreBonusTypes.init(rawValue: 1 << 1)
    static let skillBoost = LSScoreBonusTypes.init(rawValue: 1 << 2)
    static let heal = LSScoreBonusTypes.init(rawValue: 1 << 3)
    static let overload = LSScoreBonusTypes.init(rawValue: 1 << 4)
    static let deep: LSScoreBonusTypes = [.comboBonus, .perfectBonus]
    static let allRound: LSScoreBonusTypes = [.comboBonus, .heal]
    
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
        default:
            return nil
        }
    }
    
    var hashValue: Int {
        return Int(self.rawValue)
    }
}

struct LSScoreBonus {
    
    var range: LSRange
    
    // In percent, 117 means 17%up
    var value: Int
    
    var type: LSScoreBonusTypes
    
    // In 0 - 10000
    var rate: Double
    
    // In percent, 30 means 0.3
    var rateBonus: Int
    
    var triggerLife: Int
    
    var probability: Double {
        return min(1, rate * Double(100 + rateBonus) / 1000000)
    }
    
}
