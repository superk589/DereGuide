//
//  CGSSLiveSimulator.swift
//  CGSSGuide
//
//  Created by zzk on 2017/2/19.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias LSResultClosure = (LSResult, [LSLog]) -> Void

fileprivate extension Int {
    func addGreatPercent(_ percent: Double) -> Int {
        return Int(round(Double(self) * (1 - 0.3 * percent / 100)))
    }
}

class CGSSLiveSimulator {
    
    var notes: [LSNote]
    var bonuses: [LSSkill]
    var supports: [LSSkill]
    var totalLife: Int
    
    init(notes: [LSNote], bonuses: [LSSkill], supports: [LSSkill], totalLife: Int) {
        self.notes = notes
        self.bonuses = bonuses
        self.supports = supports
        self.totalLife = totalLife
    }

    var simulateResult = [Int]()
    
    
    func simulateOptimistic1(options: LSOptions = [], callback: LSResultClosure? = nil) {
        var sum = 0
        
        let sortedBonuses = bonuses.sorted { $0.range.begin < $1.range.begin }
        
        var logs = [LSLog]()
       
        var lastIndex = 0
        for i in 0..<notes.count {
            let note = notes[i]
            let baseScore = note.baseScore
            let comboFactor = note.comboFactor
            var bonusGroup = LSScoreBonusGroup.basic
            let noteRange = LSRange(begin: note.sec - 0.06, length: 0.12)
            
            var firstLoop = true
            var intersectedRanges = [LSRange]()
            var intersectedBonuses = [LSSkill]()
            for j in lastIndex..<sortedBonuses.count {
                let bonus = sortedBonuses[j]
                if note.sec - 0.06 > bonus.range.end {
                    continue
                } else if note.sec + 0.06 < bonus.range.begin {
                    break
                } else {
                    if firstLoop {
                        lastIndex = j
                        firstLoop = false
                    }
                    if let intersectedRange = bonus.range.intersection(noteRange) {
                        intersectedRanges.append(intersectedRange)
                    }
                    intersectedBonuses.append(bonus)
                }
            }
            
            if intersectedRanges.count > 0 {
                var intersectedPoints = [Float]()
                for range in intersectedRanges {
                    intersectedPoints.append(range.begin)
                    intersectedPoints.append(range.end)
                }
                // remove redundant
                intersectedPoints = Array(Set(intersectedPoints))
                intersectedPoints.sort()
                
                // assert(intersectedPoints.count > 1)
                var subRanges = [LSRange]()
                for k in 0..<intersectedPoints.count - 1 {
                    let point = intersectedPoints[k]
                    let nextPoint = intersectedPoints[k + 1]
                    let range = LSRange.init(begin: point, length: nextPoint - point)
                    subRanges.append(range)
                }
                
                for range in subRanges {
                    var subBonusGroup = LSScoreBonusGroup.basic
                   
                    for bonus in intersectedBonuses {
                        if bonus.range.contains(range) {
                            switch bonus.type {
                            case .comboBonus, .allRound:
                                subBonusGroup.baseComboBonus = max(subBonusGroup.baseComboBonus, bonus.value)
                            case .perfectBonus, .overload:
                                subBonusGroup.basePerfectBonus = max(subBonusGroup.basePerfectBonus, bonus.value)
                            case .skillBoost:
                                subBonusGroup.skillBoost = max(subBonusGroup.skillBoost, bonus.value)
                            case .deep:
                                subBonusGroup.basePerfectBonus = max(subBonusGroup.basePerfectBonus, bonus.value)
                                subBonusGroup.baseComboBonus = max(subBonusGroup.baseComboBonus, bonus.value2)
                            default:
                                break
                            }
                        }
                    }
    
                    if subBonusGroup.bonusValue > bonusGroup.bonusValue {
                        bonusGroup = subBonusGroup
                    }
                }
            }
            
            let score = Int(round(baseScore * comboFactor * Double(bonusGroup.bonusValue) / 10000))
            
            sum += score
            
            if options.contains(.detailLog) {
                let log = LSLog.init(noteIndex: i + 1, score: score, sum: sum, baseScore: baseScore, baseComboBonus: bonusGroup.baseComboBonus, comboBonus: bonusGroup.comboBonus, basePerfectBonus: bonusGroup.basePerfectBonus, perfectBonus: bonusGroup.perfectBonus, comboFactor: comboFactor, skillBoost: bonusGroup.skillBoost, lifeRestore: 0, currentLife: 0, perfectLock: false, comboContinue: false, guard: false)
                logs.append(log)
            }
        }
        simulateResult.append(sum)
        callback?(LSResult.init(scores: simulateResult), logs)
    }
    
    func simulateOnce(options: LSOptions = [], callback: LSResultClosure? = nil) {
        var sum = 0
        
        var life = totalLife

        var procedBonuses: [LSSkill]
        if options.contains(.supportSkills) {
            procedBonuses = supports.sorted { $0.range.begin < $1.range.begin }.filter {
                options.contains(.maxRate) || CGSSGlobal.isProc(rate: Int(round($0.rate * Double(100 + $0.rateBonus) / 10)))
            }
        } else {
            procedBonuses = bonuses.sorted { $0.range.begin < $1.range.begin }.filter {
                options.contains(.maxRate) || CGSSGlobal.isProc(rate: Int(round($0.rate * Double(100 + $0.rateBonus) / 10)))
            }
        }
        
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
            for j in lastIndex..<procedBonuses.count {
                let bonus = procedBonuses[j]
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
                    case .perfectBonus:
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
                    }
                }
            }
            
            if bonusGroup.skillBoost > 1000 {
                if restoreLife != 0 || damageGuard {
                    restoreLife += 1
                }
            }
            
            life = min(totalLife, life + restoreLife)
            
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
        
        simulateResult.append(sum.addGreatPercent(UserDefaults.standard.greatPercent))
        callback?(LSResult.init(scores: simulateResult), logs)
        
//        #if DEBUG
//            let arr = scores.map { $0.toDictionary }
//            let json = JSON(arr)
//            try? json.rawString()?.write(toFile: NSHomeDirectory() + "/test.txt", atomically: true, encoding: .utf8)
//        #endif
    }
    
    
    
    func wipeResults() {
        simulateResult.removeAll()
    }
    
    func simulate(times: UInt, options: LSOptions = [], progress: CGSSProgressClosure = { _,_ in }, callback: @escaping LSResultClosure) {
        for i in 0..<times {
            simulateOnce(options: options)
            progress(Int(i + 1), Int(times))
        }
        let result = LSResult.init(scores: simulateResult)
        callback(result, [])
    }
}

