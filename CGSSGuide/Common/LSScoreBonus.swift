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
    static let deep: LSScoreBonusTypes = [.comboBonus, .perfectBonus]
    
    init?(type: CGSSSkillTypes) {
        switch type {
        case CGSSSkillTypes.comboBonus, CGSSSkillTypes.allRound:
            self = .comboBonus
        case CGSSSkillTypes.perfectBonus, CGSSSkillTypes.overload, CGSSSkillTypes.concentration:
            self = .perfectBonus
        case CGSSSkillTypes.deepCool, CGSSSkillTypes.deepCute, CGSSSkillTypes.deepPassion:
            self = [.perfectBonus, .comboBonus]
        case CGSSSkillTypes.boost:
            self = .skillBoost
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
    
    var probability: Double {
        return min(1, rate * Double(100 + rateBonus) / 1000000)
    }
}
