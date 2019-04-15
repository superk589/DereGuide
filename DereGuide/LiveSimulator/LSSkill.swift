//
//  LSSkill.swift
//  DereGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017 zzk. All rights reserved.
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
    
    case synergy
    
    case coordination
    case turning
    
    static let allPerfectBonus: [LSSkillType] = [LSSkillType.perfectBonus, .overload, .deep, .concentration, .synergy, .coordination]
    static let allComboBonus: [LSSkillType] = [LSSkillType.allRound, .comboBonus, .deep, .synergy, .coordination, .turning]
    static let allLifeResotre: [LSSkillType] = [LSSkillType.allRound, .heal, .synergy]

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
        case CGSSSkillTypes.synergy:
            self = .synergy
        case CGSSSkillTypes.coordination:
            self = .coordination
        case CGSSSkillTypes.tuning:
            self = .turning
        default:
            return nil
        }
    }
}

struct LSTriggerEvaluations: OptionSet {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let perfect = LSTriggerEvaluations(rawValue: 1 << 0)
    static let great = LSTriggerEvaluations(rawValue: 1 << 1)
    static let nice = LSTriggerEvaluations(rawValue: 1 << 2)
    static let bad = LSTriggerEvaluations(rawValue: 1 << 3)
    static let miss = LSTriggerEvaluations(rawValue: 1 << 4)
    static let all: LSTriggerEvaluations = [.perfect, .great, .nice, .bad, .miss]
}

struct LSSkill {
    
    var range: LSRange<Float>
    
    /// in percent, 117 means 17%up
    var value: Int
    
    /// heal of all round / combo bonus of deep
    var value2: Int
    
    /// heal of three color synegy
    var value3: Int
    
    var type: LSSkillType
    
    /// 0 ~ 10000
    var rate: Int
    
    /// in percent, 30 means 0.3
    var rateBonus: Int
    
    /// in percent, 20 means 0.2
    var ratePotentialBonus: Int
    
    /// overload skills' trigger life value
    var triggerLife: Int
    
    /// 0 ~ 4, the index of the member in the unit
    var position: Int
    
    /// what kind of note evaluation can get bonus of effect 1
    var triggerEvaluations1: LSTriggerEvaluations
    
    /// what kind of note evaluation can get bonus of effect 2
    var triggerEvaluations2: LSTriggerEvaluations
    
    /// what kind of note evaluation can get bonus of effect 3
    var triggerEvaluations3: LSTriggerEvaluations
    
    var baseRarity: CGSSRarityTypes
}

extension LSSkill {
    
    var probability: Double {
        return min(1, Double(rate * (100 + rateBonus)) / 1000000)
    }
    
    var isConcentrated: Bool {
        return type == .concentration
    }
    
}

extension LSSkill {
    
    var comboBonusValue: Int {
        if type == .deep || type == .synergy || type == .coordination {
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
        } else if type == .synergy {
            return value3
        } else if LSSkillType.allLifeResotre.contains(type) {
            return value
        } else {
            return 0
        }
    }
}

extension CGSSSkill {
    
    var triggerEvaluations1: LSTriggerEvaluations {
        switch skillTypeId {
        case 1, 14, 15, 17, 21, 22, 23, 26, 27:
            return .perfect
        case 2, 18:
            return [.perfect, .great]
        case 3, 19:
            return [.perfect, .great, .nice]
        case 13:
            return [.perfect, .great, .nice, .bad, .miss]
        case 5:
            return .great
        case 6:
            return [.great, .nice]
        case 7:
            return [.great, .nice, .bad]
        case 8:
            return [.great, .nice, .bad, .miss]
        case 9:
            return .nice
        case 10:
            return [.bad, .nice]
        case 31:
            return [.perfect]
        default:
            return .all
        }
        
    }
    
    // for the second effect of focus, all round and overload
    var triggerEvaluations2: LSTriggerEvaluations {
        switch skillTypeId {
        case 14:
            return [.nice, .bad]
        case 24:
            return .perfect
        case 31:
            return [.great, .nice]
        default:
            return .all
        }
    }
    
    var triggerEvalutions3: LSTriggerEvaluations {
        switch skillTypeId {
        case 26:
            return [.perfect]
        default:
            return .all
        }
    }
}
