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
            return 3
        case .skillStart:
            return 1
        case .note:
            return 2
        }
    }
}

struct LSGame {
    
    var maxLife: Int
    var currentLife: Int
    var score: Int
    var logs = [LSLog]()
    var skills = [Identifier: LSSkill]()
    var optimisticNotes = [Identifier: LSNote]()
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
            
            //calculate score
            let noteScore = Int(round(note.baseScore * note.comboFactor * Double(bonusGroup.bonusValue) / 10000))
            score += noteScore
            
            // calculate life
            var lifeRestoreValue = bestLifeRestore?.lifeRestoreValue ?? 0
            if hasSkillBoost {
                if hasDamegeGuard && lifeRestoreValue == 0 {
                    lifeRestoreValue = 1
                } else if lifeRestoreValue > 0 {
                    lifeRestoreValue += 1
                }
            }
            currentLife = min(maxLife, currentLife + lifeRestoreValue)
            
            if shouldGenerateLogs {
                let log = LSLog(noteIndex: combo, score: noteScore, sum: score,
                                baseScore: note.baseScore,
                                baseComboBonus: bonusGroup.baseComboBonus,
                                comboBonus: bonusGroup.comboBonus,
                                basePerfectBonus: bonusGroup.basePerfectBonus,
                                perfectBonus: bonusGroup.perfectBonus,
                                comboFactor: note.comboFactor,
                                skillBoost: bonusGroup.skillBoost,
                                lifeRestore: lifeRestoreValue,
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
                    skills[id] = skill
                    lastSkill = skill
                }
            case .encore:
                if var last = lastSkill {
                    last.range = skill.range
                    perform(.skillStart(id, last))
                }
            default:
                skills[id] = skill
                lastSkill = skill
            }
        case .skillEnd(let id, _):
            skills[id] = nil
        }
    }
    
    private var lastSkill: LSSkill?
    
    var hasConcentration: Bool {
        return skills.values.contains{ $0.type == .concentration }
    }
    
    private var hasDamegeGuard: Bool {
        return skills.values.contains{ $0.type == .guard }
    }
    
    private var hasPerfectSupport: Bool {
        return skills.values.contains{ $0.type == .perfectLock }
    }
    
    private var hasComboSupport: Bool {
        return skills.values.contains{ $0.type == .comboContinue }
    }
    
    private var hasSkillBoost: Bool {
        return skills.values.contains{ $0.type == .skillBoost }
    }
    
    private var hasLifeSparkle: Bool {
        return skills.values
            .contains { $0.type == .lifeSparkle }
    }
    
    private var bestPerfectBonus: LSSkill? {
        return skills.values
            .filter { LSSkillType.allPerfectBonus.contains($0.type) }
            .max { $0.value < $1.value }
    }
    
    // combo bonus without life sparkle
    private var bestComboBonus: LSSkill? {
        return skills.values
            .filter { LSSkillType.allComboBonus.contains($0.type) }
            .max { $0.comboBonusValue < $1.comboBonusValue }
    }
    
    private var bestSkillBoost: LSSkill? {
        return skills.values
            .filter { $0.type == .skillBoost }
            .max { $0.value < $1.value }
    }
    
    private var bestLifeRestore: LSSkill? {
        return skills.values
            .filter { LSSkillType.allLifeResotre.contains($0.type) }
            .max { $0.value < $1.value }
    }
    
    var bonusGroup: LSScoreBonusGroup {
        let maxPerfectBonus = bestPerfectBonus?.value ?? 100
        let maxComboBonus = bestComboBonus?.comboBonusValue ?? 100
        let lifeSparkleBonus = hasLifeSparkle ? LiveCoordinator.comboBonusValueOfLife(currentLife) : 100
        let maxSkillBoost = bestSkillBoost?.value ?? 1000
        return LSScoreBonusGroup(basePerfectBonus: maxPerfectBonus, baseComboBonus: max(maxComboBonus, lifeSparkleBonus), skillBoost: maxSkillBoost)
    }
    
}
