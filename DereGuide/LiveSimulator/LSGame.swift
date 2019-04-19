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
    
    // used for order the actions with the same time offset
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
            // whenever current life is changed, we should update life sparkle bonus value if needed.
            if hasLifeSparkle {
                updateBonusGroup()
            }
        }
    }
    var score: Int
    var numberOfNotes: Int
    var logs = [LSLog]()
    var skills = [Identifier: LSSkill]()
    var combo = 0
    var noteIndex = 0
    var shouldGenerateLogs = false
    var afkMode = false
    var difficulty: CGSSLiveDifficulty
    var isDead = false
    var missedNotes = [LSNote]()
    
    init(initialLife: Int, maxLife: Int, numberOfNotes: Int, difficulty: CGSSLiveDifficulty, score: Int = 0) {
        self.currentLife = initialLife
        self.maxLife = maxLife
        self.score = score
        self.numberOfNotes = numberOfNotes
        self.difficulty = difficulty
    }
    
    mutating func perform(_ action: LSAction) {
        switch action {
        case .note(let note):
            noteIndex += 1
            if isDead {
                processNoteAfterDead(note)
            } else if afkMode && !(hasSkillBoost && hasStrongPerfectSupport) && note.sec > LiveSimulationAdvanceOptionsManager.default.afkModeStartSeconds && noteIndex > LiveSimulationAdvanceOptionsManager.default.afkModeStartCombo {
                // if in afk mode, note will be missed unless skill boost and perfect support are on
                processMissingNote(note)
                missedNotes.append(note)
            } else {
                if afkMode && ([.hold, .slide].contains(note.rangeType) && missedNotes.contains(where: { (missedNote) -> Bool in
                    return missedNote.beatmapNote === note.beatmapNote.previous
                })) {
                    processSilentlyMissingNote(note)
                    missedNotes.append(note)
                } else {
                    processNormalNote(note)
                }
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
    
    private mutating func processMissingNote(_ note: LSNote) {
        combo = 0
        
        // calculate life loss
        let lostLife: Int
        if hasDamegeGuard || ([.hold, .slide].contains(note.rangeType) && missedNotes.contains(where: { (missedNote) -> Bool in
            return missedNote.beatmapNote === note.beatmapNote.previous
        })) {
            lostLife = 0
        } else {
            lostLife = note.lifeLost(in: difficulty, evaluation: .miss)
        }
        
        currentLife = max(0, currentLife - lostLife)
        
        if currentLife == 0 {
            isDead = true
            score = 0
        }
        
        let noteScore = 0
        
        generateLogIfNeeded(noteIndex: noteIndex, score: noteScore, sum: score,
                            baseScore: note.baseScore,
                            baseComboBonus: bonusGroup.baseComboBonus,
                            comboBonus: bonusGroup.comboBonus,
                            basePerfectBonus: bonusGroup.basePerfectBonus,
                            perfectBonus: bonusGroup.perfectBonus,
                            comboFactor: 0,
                            skillBoost: bonusGroup.skillBoost,
                            lifeRestore: -lostLife,
                            currentLife: currentLife,
                            perfectLock: hasPerfectSupport,
                            strongPerfectLock: hasStrongPerfectSupport,
                            comboContinue: hasComboSupport,
                            guard: hasDamegeGuard)
    }
    
    // for the note followed any note of a missed slide or long press note
    private mutating func processSilentlyMissingNote(_ note: LSNote) {
        generateLogIfNeeded(noteIndex: noteIndex, score: 0, sum: score,
                            baseScore: note.baseScore,
                            baseComboBonus: bonusGroup.baseComboBonus,
                            comboBonus: bonusGroup.comboBonus,
                            basePerfectBonus: bonusGroup.basePerfectBonus,
                            perfectBonus: bonusGroup.perfectBonus,
                            comboFactor: 0,
                            skillBoost: bonusGroup.skillBoost,
                            lifeRestore: 0,
                            currentLife: currentLife,
                            perfectLock: hasPerfectSupport,
                            strongPerfectLock: hasStrongPerfectSupport,
                            comboContinue: hasComboSupport,
                            guard: hasDamegeGuard)
    }
    
    private mutating func processNoteAfterDead(_ note: LSNote) {
        generateLogIfNeeded(noteIndex: noteIndex, score: 0, sum: 0,
                            baseScore: note.baseScore,
                            baseComboBonus: bonusGroup.baseComboBonus,
                            comboBonus: bonusGroup.comboBonus,
                            basePerfectBonus: bonusGroup.basePerfectBonus,
                            perfectBonus: bonusGroup.perfectBonus,
                            comboFactor: 0,
                            skillBoost: bonusGroup.skillBoost,
                            lifeRestore: 0,
                            currentLife: 0,
                            perfectLock: hasPerfectSupport,
                            strongPerfectLock: hasStrongPerfectSupport,
                            comboContinue: hasComboSupport,
                            guard: hasDamegeGuard)
    }
    
    private mutating func processNormalNote(_ note: LSNote) {
            
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
        
        // calculate combo factor
        let comboFactor: Double
        if afkMode {
            updateComboFactor()
            comboFactor = self.comboFactor
        } else {
            comboFactor = note.comboFactor
        }
        
        // calculate score
        let noteScore: Int
        let noteBonusGroup: LSScoreBonusGroup
        switch note.noteType {
        case .flick:
            noteScore = Int(round(note.baseScore * comboFactor * Double(bonusGroupForFlick.bonusValue) / 10000))
            noteBonusGroup = bonusGroupForFlick
        case .hold:
            noteScore = Int(round(note.baseScore * comboFactor * Double(bonusGroupForHold.bonusValue) / 10000))
            noteBonusGroup = bonusGroupForHold
        default:
            noteScore = Int(round(note.baseScore * comboFactor * Double(bonusGroup.bonusValue) / 10000))
            noteBonusGroup = bonusGroup
        }
        score += noteScore
        
        // generate log
        generateLogIfNeeded(noteIndex: noteIndex, score: noteScore, sum: score,
                            baseScore: note.baseScore,
                            baseComboBonus: noteBonusGroup.baseComboBonus,
                            comboBonus: noteBonusGroup.comboBonus,
                            basePerfectBonus: noteBonusGroup.basePerfectBonus,
                            perfectBonus: noteBonusGroup.perfectBonus,
                            comboFactor: comboFactor,
                            skillBoost: noteBonusGroup.skillBoost,
                            lifeRestore: restoredLife,
                            currentLife: currentLife,
                            perfectLock: hasPerfectSupport,
                            strongPerfectLock: hasStrongPerfectSupport,
                            comboContinue: hasComboSupport,
                            guard: hasDamegeGuard)
    }
    
    @inline(__always)
    private mutating func generateLogIfNeeded(noteIndex: Int, score: Int, sum: Int, baseScore: Double,
                                               baseComboBonus: Int, comboBonus: Int, basePerfectBonus: Int,
                                               perfectBonus: Int, comboFactor: Double, skillBoost: Int,
                                               lifeRestore: Int, currentLife: Int, perfectLock: Bool,
                                               strongPerfectLock: Bool, comboContinue: Bool, guard: Bool) {
        if shouldGenerateLogs {
            let log = LSLog(noteIndex: noteIndex, score: score, sum: sum,
                            baseScore: baseScore,
                            baseComboBonus: baseComboBonus,
                            comboBonus: comboBonus,
                            basePerfectBonus: basePerfectBonus,
                            perfectBonus: perfectBonus,
                            comboFactor: comboFactor,
                            skillBoost: skillBoost,
                            lifeRestore: lifeRestore,
                            currentLife: currentLife,
                            perfectLock: perfectLock,
                            strongPerfectLock: strongPerfectLock,
                            comboContinue: comboContinue,
                            guard: `guard`)
            logs.append(log)
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
            updateComboSupport()
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
        case .synergy:
            updateHealer()
            updatePerfectBonus()
            updateComboBonus()
        case .coordination:
            updatePerfectBonus()
            updateComboBonus()
        case .flickAct:
            updatePerfectBonus()
        case .longAct:
            updatePerfectBonus()
        case .turning:
            updatePerfectSupport()
            updateComboBonus()
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
    private(set) var hasStrongPerfectSupport = false
    private mutating func updatePerfectSupport() {
        hasPerfectSupport = skills.values.contains { $0.type == .perfectLock || $0.type == .turning }
        hasStrongPerfectSupport = skills.values.contains { $0.type == .perfectLock && $0.triggerEvaluations1.contains(.bad) }
    }
    
    private(set) var hasComboSupport = false
    
    private mutating func updateComboSupport() {
        hasComboSupport = skills.values.contains { $0.type == .comboContinue || $0.type == .overload }
    }
    
    private(set) var hasSkillBoost = false
    
    private(set) var bestSkillBoost: LSSkill?
    
    private mutating func updateSkillBoost() {
        hasSkillBoost = skills.values.contains { $0.type == .skillBoost }
        bestSkillBoost = skills.values
            .filter { $0.type == .skillBoost }
            .max { $0.value < $1.value }
        updateBonusGroup()
    }
    
    private(set) var hasLifeSparkle = false
    private(set) var bestLifeSparkle: LSSkill?
    
    private mutating func updateLifeSparkle() {
        bestLifeSparkle = skills.values
            .filter { $0.type == .lifeSparkle }
            .max { $0.baseRarity.rawValue < $1.baseRarity.rawValue }
        hasLifeSparkle = bestLifeSparkle != nil
        updateBonusGroup()
    }
    
    private(set) var bestPerfectBonus: LSSkill?
    private(set) var bestPerfectBonusForFlick: LSSkill?
    private(set) var bestPerfectBonusForHold: LSSkill?
    
    private mutating func updatePerfectBonus() {
        bestPerfectBonus = skills.values
            .filter { LSSkillType.allPerfectBonus.contains($0.type) }
            .max { $0.perfectBonusValue(noteType: .click) < $1.perfectBonusValue(noteType: .click) }
        bestPerfectBonusForFlick = skills.values
            .filter { LSSkillType.allPerfectBonus.contains($0.type) }
            .max { $0.perfectBonusValue(noteType: .flick) < $1.perfectBonusValue(noteType: .flick) }
        bestPerfectBonusForHold = skills.values
            .filter { LSSkillType.allPerfectBonus.contains($0.type) }
            .max { $0.perfectBonusValue(noteType: .hold) < $1.perfectBonusValue(noteType: .hold) }
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
            .max { $0.lifeValue < $1.lifeValue }
    }
    
    private(set) var bonusGroup: LSScoreBonusGroup = .basic
    private(set) var bonusGroupForHold: LSScoreBonusGroup = .basic
    private(set) var bonusGroupForFlick: LSScoreBonusGroup = .basic
    
    private mutating func updateBonusGroup() {
        let maxPerfectBonus = bestPerfectBonus?.perfectBonusValue(noteType: .click) ?? 100
        let maxComboBonus = bestComboBonus?.comboBonusValue ?? 100
        let lifeSparkleBonus = hasLifeSparkle ? LiveCoordinator.comboBonusValueOfLife(currentLife, baseRarity: bestLifeSparkle!.baseRarity) : 100
        let maxSkillBoost = bestSkillBoost?.value ?? 1000
        bonusGroup = LSScoreBonusGroup(basePerfectBonus: maxPerfectBonus, baseComboBonus: max(maxComboBonus, lifeSparkleBonus), skillBoost: maxSkillBoost)
        bonusGroupForHold = LSScoreBonusGroup(basePerfectBonus: bestPerfectBonusForHold?.perfectBonusValue(noteType: .hold) ?? 100, baseComboBonus: max(maxComboBonus, lifeSparkleBonus), skillBoost: maxSkillBoost)
        bonusGroupForFlick = LSScoreBonusGroup(basePerfectBonus: bestPerfectBonusForFlick?.perfectBonusValue(noteType: .flick) ?? 100, baseComboBonus: max(maxComboBonus, lifeSparkleBonus), skillBoost: maxSkillBoost)
    }
    
    // MARK: Combo factor calculation
    
    private var comboFactor = 1.0
    lazy var comboFactorIndexes: [(Int, Double)] = {
        return zip([0, 5, 10, 25, 50, 70, 80, 90], [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.7, 2.0]).map {
            (Int(floor(Float(self.numberOfNotes * $0.0) / 100)), $0.1)
        }
    }()

    private mutating func updateComboFactor() {
        comboFactor = comboFactorIndexes.last { combo >= $0.0 }?.1 ?? 1.0
    }
    
}
