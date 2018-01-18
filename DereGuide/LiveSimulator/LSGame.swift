//
//  LSGame.swift
//  DereGuide
//
//  Created by zzk on 06/01/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

typealias Identifier = String

enum LSAction {
    case skillStart(Identifier, LSSkill)
    case skillEnd(Identifier, LSSkill)
    case note(LSNote)
    
    // time offset from live start, in seconds
    var timeOffset: Float {
        switch self {
        case .skillEnd(_, let skill):
            return skill.range.end
        case .skillStart(_, let skill):
            return skill.range.begin
        case .note(let note):
            return note.sec
        }
    }
    
    // used for order the actions have the same time offset
    var order: Int {
        switch self {
        case .skillEnd:
            return 300
        case .skillStart(_, let skill):
            switch skill.position {
            case 0:
                return 102
            case 1:
                return 104
            case 2:
                return 105
            case 3:
                return 103
            case 4:
                return 101
            default:
                return 100
            }
        case .note:
            return 200
        }
    }
}

struct LSGame {
    
    var maxLife: Int
    var currentLife: Int {
        didSet {
            // whenever current life is changed, we should update life sparkle bonus value.
            if hasLifeSparkle {
                updateBonusGroup()
            }
        }
    }
    var score: Int
    var logs = [LSLog]()
    var skills = [Identifier: LSSkill]()
    var combo = 0
    var shouldGenerateLogs = false
    
    init(initialLife: Int, maxLife: Int, score: Int = 0) {
        self.currentLife = initialLife
        self.maxLife = maxLife
        self.score = score
    }
    
    mutating func perform(_ action: LSAction) {
        switch action {
        case .note(let note):
            
            combo += 1

            // calculate life (as restored life may change life sparkle bonus value. And in fact, restoring life is calculated first)
            var restoredLife = bestHealer?.lifeValue ?? 0
            if hasSkillBoost {
                if hasDamegeGuard && restoredLife == 0 {
                    restoredLife = 1
                } else if restoredLife > 0 {
                    restoredLife += 1
                }
            }
            currentLife = min(maxLife, currentLife + restoredLife)
            
            // calculate score
            let noteScore = Int(round(note.baseScore * note.comboFactor * Double(bonusGroup.bonusValue) / 10000))
            score += noteScore
            
            // generate log
            if shouldGenerateLogs {
                let log = LSLog(noteIndex: combo, score: noteScore, sum: score,
                                baseScore: note.baseScore,
                                baseComboBonus: bonusGroup.baseComboBonus,
                                comboBonus: bonusGroup.comboBonus,
                                basePerfectBonus: bonusGroup.basePerfectBonus,
                                perfectBonus: bonusGroup.perfectBonus,
                                comboFactor: note.comboFactor,
                                skillBoost: bonusGroup.skillBoost,
                                lifeRestore: restoredLife,
                                currentLife: currentLife,
                                perfectLock: hasPerfectSupport,
                                comboContinue: hasComboSupport,
                                guard: hasDamegeGuard)
                logs.append(log)
            }
        case .skillStart(let id, let skill):
            switch skill.type {
            case .overload:
                if currentLife - skill.triggerLife > 0 {
                    currentLife -= skill.triggerLife
                    addSkill(id: id, skill: skill)
                }
            case .encore:
                if var last = lastSkill {
                    last.range = skill.range
                    perform(.skillStart(id, last))
                }
            default:
                addSkill(id: id, skill: skill)
            }
        case .skillEnd(let id, let skill):
            removeSkill(id: id, skill: skill)
        }
    }
    
    private mutating func addSkill(id: Identifier, skill: LSSkill) {
        skills[id] = skill
        lastSkill = skill
        updateStatusBy(skillType: skill.type)
    }
    
    private mutating func removeSkill(id: Identifier, skill: LSSkill) {
        skills[id] = nil
        updateStatusBy(skillType: skill.type)
    }
    
    private mutating func updateStatusBy(skillType: LSSkillType) {
        switch skillType {
        case .allRound:
            updateComboBonus()
            updateHealer()
        case .comboBonus:
            updateComboBonus()
        case .perfectBonus:
            updatePerfectBonus()
        case .skillBoost:
            updateSkillBoost()
        case .heal:
            updateHealer()
        case .overload:
            updatePerfectBonus()
        case .deep:
            updatePerfectBonus()
            updateComboBonus()
        case .concentration:
            updateConcentration()
            updatePerfectBonus()
        case .`guard`:
            updateDamageGuard()
        case .comboContinue:
            updateComboSupport()
        case .perfectLock:
            updatePerfectSupport()
        case .lifeSparkle:
            updateLifeSparkle()
        default:
            break
        }
    }
    
    private var lastSkill: LSSkill?
    
    private(set) var hasConcentration = false
    
    private mutating func updateConcentration() {
        hasConcentration = skills.values.contains{ $0.type == .concentration }
    }
    
    private(set) var hasDamegeGuard = false
    
    private mutating func updateDamageGuard() {
        hasDamegeGuard = skills.values.contains{ $0.type == .guard }
    }
    
    private(set) var hasPerfectSupport = false
    
    private mutating func updatePerfectSupport() {
         hasPerfectSupport = skills.values.contains{ $0.type == .perfectLock }
    }
    
    private(set) var hasComboSupport = false
    
    private mutating func updateComboSupport() {
        hasComboSupport = skills.values.contains{ $0.type == .comboContinue }
    }
    
    private(set) var hasSkillBoost = false
    
    private(set) var bestSkillBoost: LSSkill?
    
    private mutating func updateSkillBoost() {
        hasSkillBoost = skills.values.contains{ $0.type == .skillBoost }
        bestSkillBoost = skills.values
            .filter { $0.type == .skillBoost }
            .max { $0.value < $1.value }
        updateBonusGroup()
    }
    
    private(set) var hasLifeSparkle = false
    
    private mutating func updateLifeSparkle() {
        hasLifeSparkle = skills.values
            .contains { $0.type == .lifeSparkle }
    }
    
    private(set) var bestPerfectBonus: LSSkill?
    
    private mutating func updatePerfectBonus() {
        bestPerfectBonus = skills.values
            .filter { LSSkillType.allPerfectBonus.contains($0.type) }
            .max { $0.value < $1.value }
        updateBonusGroup()
    }
    
    // combo bonus without life sparkle
    private(set) var bestComboBonus: LSSkill?
    
    private mutating func updateComboBonus() {
        bestComboBonus = skills.values
            .filter { LSSkillType.allComboBonus.contains($0.type) }
            .max { $0.comboBonusValue < $1.comboBonusValue }
        updateBonusGroup()
    }
    
    private(set) var bestHealer: LSSkill?
    
    private mutating func updateHealer() {
        bestHealer = skills.values
            .filter { LSSkillType.allLifeResotre.contains($0.type) }
            .max { $0.value < $1.value }
    }
    
    private(set) var bonusGroup: LSScoreBonusGroup = .basic
    
    private mutating func updateBonusGroup() {
        let maxPerfectBonus = bestPerfectBonus?.value ?? 100
        let maxComboBonus = bestComboBonus?.comboBonusValue ?? 100
        let lifeSparkleBonus = hasLifeSparkle ? LiveCoordinator.comboBonusValueOfLife(currentLife) : 100
        let maxSkillBoost = bestSkillBoost?.value ?? 1000
        bonusGroup = LSScoreBonusGroup(basePerfectBonus: maxPerfectBonus, baseComboBonus: max(maxComboBonus, lifeSparkleBonus), skillBoost: maxSkillBoost)
    }
    
}
