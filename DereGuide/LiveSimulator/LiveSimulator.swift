//
//  LiveSimulator.swift
//  DereGuide
//
//  Created by zzk on 2017/2/19.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias LSResultClosure = (LSResult, [LSLog]) -> Void

class LiveSimulator {
    
    var notes: [LSNote]
    var bonuses: [LSSkill]
    var totalLife: Int
    var difficulty: CGSSLiveDifficulty
    
    init(notes: [LSNote], bonuses: [LSSkill], totalLife: Int, difficulty: CGSSLiveDifficulty) {
        self.notes = notes
        self.bonuses = bonuses
        self.totalLife = totalLife
        self.difficulty = difficulty
    }

    var simulateResult = [Int]()
    
    func simulateOptimistic1(options: LSOptions = [], callback: LSResultClosure? = nil) {

        var actions = [LSAction]()
        for (index, bonus) in bonuses.enumerated() {
            actions += [LSAction.skillStart(String(index), bonus), .skillEnd(String(index), bonus)]
        }
        
        actions.sort { $0.timeOffset < $1.timeOffset }
        
        var game = LSGame(initialLife: totalLife, maxLife: 2 * totalLife)
        
        if options.contains(.detailLog) {
            game.shouldGenerateLogs = true
        }
        
        var actionSlice = ArraySlice(actions)
        
        for note in notes {
            let radius = perfectRadius[difficulty]![note.rangeType]!
            let concentratedRadius = concentratedPerfectRadius[difficulty]![note.rangeType]!
            
            // perform all action before the note
            while let action = actionSlice.first, action.timeOffset < note.sec - (game.hasConcentration ? concentratedRadius : radius) {
                actionSlice.removeFirst()
                game.perform(action)
            }
            
            // tempGame and tampActionSlice are used to retain the highest score among all tries
            var tempGame = game
            var tempActionSlice = actionSlice
            tempGame.perform(.note(note))
            
            // try on a snapshot of current game
            var snapshotActionSlice = actionSlice
            var snapshot = game
            
            while let action = snapshotActionSlice.first, action.timeOffset < note.sec + radius {
                snapshotActionSlice.removeFirst()
                snapshot.perform(action)
                if snapshot.hasConcentration && action.timeOffset > note.sec + concentratedRadius {
                    continue
                }
                var oneTry = snapshot
                oneTry.perform(.note(note))
                if oneTry.score > tempGame.score {
                    tempGame = oneTry
                    tempActionSlice = snapshotActionSlice
                }
            }
            
            game = tempGame
            actionSlice = tempActionSlice
        }
        
        let score = game.score.addGreatPercent(LiveSimulationAdvanceOptionsManager.default.greatPercent)
        simulateResult.append(score)
        callback?(LSResult(scores: simulateResult), game.logs)
        
//
//        var sum = 0
//
//        var life = totalLife
////        let sortedBonuses = bonuses.sorted { $0.range.begin < $1.range.begin }
//
//        var logs = [LSLog]()
//
//        let replacedBonuses = replaceEncores(bonuses)
//
//        for i in 0..<notes.count {
//            let note = notes[i]
//            let baseScore = note.baseScore
//            let comboFactor = note.comboFactor
//            var bonusGroup = LSScoreBonusGroup.basic
//            let radius = perfectRadius[difficulty]![note.rangeType]!
//            let concentratedRadius = concentratedPerfectRadius[difficulty]![note.rangeType]!
//            let noteRange = LSRange(begin: note.sec - radius, length: 2 * radius)
//            let noteConcentratedRange = LSRange(begin: note.sec - concentratedRadius, length: concentratedRadius * 2)
//
//            var intersectedRanges = [LSRange<Float>]()
//            var intersectedBonuses = [LSSkill]()
//
//            var restoreLife = 0
//
//            for bonus in replacedBonuses {
//                if bonus.isConcentrated {
//                    if note.sec - concentratedRadius <= bonus.range.end || note.sec + concentratedRadius >= bonus.range.begin {
//                        if let intersectedRange = bonus.range.intersection(noteConcentratedRange) {
//                            intersectedRanges.append(intersectedRange)
//                        }
//                        intersectedBonuses.append(bonus)
//                    }
//                } else {
//                    if note.sec - radius <= bonus.range.end || note.sec + radius >= bonus.range.begin {
//                        if let intersectedRange = bonus.range.intersection(noteRange) {
//                            intersectedRanges.append(intersectedRange)
//                        }
//                        intersectedBonuses.append(bonus)
//                    }
//                }
//            }
//
//            if intersectedRanges.count > 0 {
//                var intersectedPoints = [Float]()
//                for range in intersectedRanges {
//                    intersectedPoints.append(range.begin)
//                    intersectedPoints.append(range.end)
//                }
//                // remove redundant
//                intersectedPoints = Array(Set(intersectedPoints))
//                intersectedPoints.sort()
//
//                // assert(intersectedPoints.count > 1)
//                var subRanges = [LSRange<Float>]()
//                for k in 0..<intersectedPoints.count - 1 {
//                    let point = intersectedPoints[k]
//                    let nextPoint = intersectedPoints[k + 1]
//                    let range = LSRange.init(begin: point, length: nextPoint - point)
//                    subRanges.append(range)
//                }
//
//                for range in subRanges {
//                    var subBonusGroup = LSScoreBonusGroup.basic
//
//                    for bonus in intersectedBonuses {
//                        if bonus.range.contains(range) {
//                            switch bonus.type {
//                            case .comboBonus:
//                                subBonusGroup.baseComboBonus = max(subBonusGroup.baseComboBonus, bonus.value)
//                            case .allRound:
//                                subBonusGroup.baseComboBonus = max(subBonusGroup.baseComboBonus, bonus.value)
//                                restoreLife = max(restoreLife, bonus.value2)
//                            case .perfectBonus, .overload, .concentration:
//                                subBonusGroup.basePerfectBonus = max(subBonusGroup.basePerfectBonus, bonus.value)
//                            case .skillBoost:
//                                subBonusGroup.skillBoost = max(subBonusGroup.skillBoost, bonus.value)
//                            case .deep:
//                                subBonusGroup.basePerfectBonus = max(subBonusGroup.basePerfectBonus, bonus.value)
//                                subBonusGroup.baseComboBonus = max(subBonusGroup.baseComboBonus, bonus.value2)
//                            case .heal:
//                                restoreLife = max(restoreLife, bonus.value)
//                            default:
//                                break
//                            }
//                        }
//                    }
//
//                    if subBonusGroup.bonusValue > bonusGroup.bonusValue {
//                        bonusGroup = subBonusGroup
//                    }
//                }
//            }
//
//            let score = Int(round(baseScore * comboFactor * Double(bonusGroup.bonusValue) / 10000))
//
//            sum += score
//
//            if options.contains(.detailLog) {
//                let log = LSLog.init(noteIndex: i + 1, score: score, sum: sum, baseScore: baseScore, baseComboBonus: bonusGroup.baseComboBonus, comboBonus: bonusGroup.comboBonus, basePerfectBonus: bonusGroup.basePerfectBonus, perfectBonus: bonusGroup.perfectBonus, comboFactor: comboFactor, skillBoost: bonusGroup.skillBoost, lifeRestore: 0, currentLife: 0, perfectLock: false, comboContinue: false, guard: false)
//                logs.append(log)
//            }
//        }
//        simulateResult.append(sum)
//        callback?(LSResult.init(scores: simulateResult), logs)
    }
    
    private func replaceEncores(_ procedBonuses: [LSSkill]) -> [LSSkill] {
        var replacedBonuses = [LSSkill]()
        for index in procedBonuses.indices {
            let bonus = procedBonuses[index]
            if bonus.type == .encore {
                if var last = replacedBonuses.last {
                    last.range = bonus.range
                    replacedBonuses.append(last)
                }
            } else {
                replacedBonuses.append(bonus)
            }
        }
        return replacedBonuses
    }
    
    func simulateOnce(options: LSOptions = [], callback: LSResultClosure? = nil) {
        
        // all proc skills
        let procedBonuses = bonuses
            .sorted { $0.range.begin < $1.range.begin }
            .filter {
                options.contains(.maxRate) || CGSSGlobal.isProc(rate: Int(round($0.rate * Double(100 + $0.rateBonus) / 10)))
            }
        
        var actions = [LSAction]()
        for (index, bonus) in procedBonuses.enumerated() {
            actions += [LSAction.skillStart(String(index), bonus), .skillEnd(String(index), bonus)]
        }

        actions += notes.map { LSAction.note($0) }
        
        actions.sort { ($0.timeOffset, $0.order) < ($1.timeOffset, $1.order)  }
        
        var game = LSGame(initialLife: totalLife, maxLife: 2 * totalLife)
        
        if options.contains(.detailLog) {
            game.shouldGenerateLogs = true
        }
        
        for action in actions {
            game.perform(action)
        }
        
        let score = game.score.addGreatPercent(LiveSimulationAdvanceOptionsManager.default.greatPercent)
        simulateResult.append(score)
        callback?(LSResult(scores: simulateResult), game.logs)
    }

    func wipeResults() {
        simulateResult.removeAll()
    }
    
    func simulateOnceFast(options: LSOptions = [], callback: LSResultClosure? = nil) {
        var sum = 0
        
        var life = totalLife
        
        // all proc skills
        let procedBonuses = bonuses
            .sorted { $0.range.begin < $1.range.begin }
            .filter {
                options.contains(.maxRate) || CGSSGlobal.isProc(rate: Int(round($0.rate * Double(100 + $0.rateBonus) / 10)))
        }
        
        // replace all encore skills by last skill
        let replacedBonuses = replaceEncores(procedBonuses)
        
        var logs = [LSLog]()
        
        var lastIndex = 0
        let overloadLimitByLife = options.contains(.overloadLimitByLife)
        var overloadedIndexes = [Int]()
        var missedIndexes = [Int]()
        
        for i in 0..<notes.count {
            let note = notes[i]
            let baseScore = note.baseScore
            let comboFactor = note.comboFactor
            var bonusGroup = LSScoreBonusGroup.basic
            var restoreLife = 0
            
            var perfectLock = false
            var comboContinue = false
            var damageGuard = false
            
            var firstLoop = true
            for j in lastIndex..<replacedBonuses.count {
                let bonus = replacedBonuses[j]
                if note.sec > bonus.range.end {
                    continue
                } else if note.sec < bonus.range.begin {
                    break
                } else {
                    if firstLoop {
                        lastIndex = j
                        firstLoop = false
                    }
                    switch bonus.type {
                    case .comboBonus:
                        bonusGroup.baseComboBonus = max(bonusGroup.baseComboBonus, bonus.value)
                    case .deep:
                        bonusGroup.basePerfectBonus = max(bonusGroup.basePerfectBonus, bonus.value)
                        bonusGroup.baseComboBonus = max(bonusGroup.baseComboBonus, bonus.value2)
                    case .allRound:
                        bonusGroup.baseComboBonus = max(bonusGroup.baseComboBonus, bonus.value)
                        restoreLife = max(restoreLife, bonus.value2)
                    case .overload:
                        comboContinue = true
                        if !overloadLimitByLife {
                            fallthrough
                        } else {
                            // not missed
                            if !missedIndexes.contains(j) {
                                
                                // proc already
                                if overloadedIndexes.contains(j) {
                                    fallthrough
                                    
                                    // first proc
                                } else {
                                    
                                    // life enough
                                    if life - bonus.triggerLife > 0 {
                                        life -= bonus.triggerLife
                                        overloadedIndexes.append(j)
                                        fallthrough
                                        
                                        // life not enough
                                    } else {
                                        missedIndexes.append(j)
                                    }
                                }
                            }
                        }
                    case .perfectBonus, .concentration:
                        bonusGroup.basePerfectBonus = max(bonusGroup.basePerfectBonus, bonus.value)
                    case .skillBoost:
                        bonusGroup.skillBoost = max(bonusGroup.skillBoost, bonus.value)
                    case .heal:
                        restoreLife = max(restoreLife, bonus.value)
                    case .comboContinue:
                        comboContinue = true
                    case .perfectLock:
                        perfectLock = true
                    case .guard:
                        damageGuard = true
                    case .lifeSparkle:
                        bonusGroup.baseComboBonus = max(bonusGroup.baseComboBonus, LiveCoordinator.comboBonusValueOfLife(life))
                    case .encore:
                        // already replaced by last skill
                        break
                    }
                }
            }
            
            if bonusGroup.skillBoost > 1000 {
                if restoreLife != 0 || damageGuard {
                    restoreLife += 1
                }
            }
            
            life = min(2 * totalLife, life + restoreLife)
            
            let score = Int(round(baseScore * comboFactor * Double(bonusGroup.bonusValue) / 10000))
            
            sum += score
            
            if options.contains(.detailLog) {
                let log = LSLog(noteIndex: i + 1, score: score, sum: sum,
                                baseScore: baseScore,
                                baseComboBonus: bonusGroup.baseComboBonus,
                                comboBonus: bonusGroup.comboBonus,
                                basePerfectBonus: bonusGroup.basePerfectBonus,
                                perfectBonus: bonusGroup.perfectBonus,
                                comboFactor: comboFactor,
                                skillBoost: bonusGroup.skillBoost,
                                lifeRestore: restoreLife,
                                currentLife: life,
                                perfectLock: perfectLock,
                                comboContinue: comboContinue,
                                guard: damageGuard)
                logs.append(log)
            }
            
        }
        
        simulateResult.append(sum.addGreatPercent(LiveSimulationAdvanceOptionsManager.default.greatPercent))
        callback?(LSResult.init(scores: simulateResult), logs)
        
        //        #if DEBUG
        //            let arr = scores.map { $0.toDictionary }
        //            let json = JSON(arr)
        //            try? json.rawString()?.write(toFile: NSHomeDirectory() + "/test.txt", atomically: true, encoding: .utf8)
        //        #endif
    }
    
    func simulate(times: UInt, options: LSOptions = [], progress: CGSSProgressClosure = { _,_ in }, callback: @escaping LSResultClosure) {
        for i in 0..<times {
            if cancelled {
                cancelled = false
                break
            }
            simulateOnce(options: options)
            progress(Int(i + 1), Int(times))
        }
        let result = LSResult.init(scores: simulateResult)
        callback(result, [])
    }
    
    private var cancelled = false
    
    func cancelSimulating() {
        cancelled = true
    }
}

extension BidirectionalCollection {
    func last(
        where predicate: (Self.Iterator.Element) throws -> Bool
        ) rethrows -> Self.Iterator.Element? {
        
        for index in self.indices.reversed() {
            let element = self[index]
            if try predicate(element) {
                return element
            }
        }
        
        return nil
    }
}


fileprivate let perfectRadius: [CGSSLiveDifficulty: [CGSSBeatmapNote.RangeType: Float]] = [
    .debut: [.click: 0.08, .slide: 0.2, .flick: 0.15],
    .regular: [.click: 0.08, .slide: 0.2, .flick: 0.15],
    .light: [.click: 0.08, .slide: 0.2, .flick: 0.15],
    .pro: [.click: 0.07, .slide: 0.2, .flick: 0.15],
    .master: [.click: 0.06, .slide: 0.2, .flick: 0.15],
    .masterPlus: [.click: 0.06, .slide: 0.2, .flick: 0.15],
    .legacyMasterPlus: [.click: 0.06, .slide: 0.2, .flick: 0.15],
    .trick: [.click: 0.06, .slide: 0.2, .flick: 0.15]
]

fileprivate let concentratedPerfectRadius: [CGSSLiveDifficulty: [CGSSBeatmapNote.RangeType: Float]] = [
    .debut: [.click: 0.05, .slide: 0.1, .flick: 0.1],
    .regular: [.click: 0.05, .slide: 0.1, .flick: 0.1],
    .light: [.click: 0.05, .slide: 0.1, .flick: 0.1],
    .pro: [.click: 0.04, .slide: 0.1, .flick: 0.1],
    .master: [.click: 0.03, .slide: 0.1, .flick: 0.1],
    .masterPlus: [.click: 0.03, .slide: 0.1, .flick: 0.1],
    .legacyMasterPlus: [.click: 0.03, .slide: 0.1, .flick: 0.1],
    .trick: [.click: 0.03, .slide: 0.1, .flick: 0.1]
]

private extension Int {
    func addGreatPercent(_ percent: Double) -> Int {
        return Int(round(Double(self) * (1 - 0.3 * percent / 100)))
    }
}

