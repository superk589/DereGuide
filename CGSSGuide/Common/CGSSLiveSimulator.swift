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

class CGSSLiveSimulator {
    
    var lsNotes: [LSNote]
    var bonuses: [LSScoreBonus]
    var supports: [LSScoreBonus]
    var notes: [CGSSBeatmapNote]
    var totalLife: Int
    
    init(distributions: [LSNote], bonuses: [LSScoreBonus], supports: [LSScoreBonus], notes: [CGSSBeatmapNote], totalLife: Int) {
        self.lsNotes = distributions
        self.bonuses = bonuses
        self.supports = supports
        self.totalLife = totalLife
        self.notes = notes
    }
    
    var averageScore: Int {
        return lsNotes.reduce(0, { $0 + $1.average })
    }
    
    var maxScore: Int {
        return lsNotes.reduce(0, { $0 + $1.max })
    }
    
    var simulateResult = [Int]()
    
    
    func simulateOptimistic1(options: LSOptions = [], callback: LSResultClosure? = nil) {
        var sum = 0
        
        let sortedBonuses = bonuses.sorted { $0.range.begin < $1.range.begin }
        
        var logs = [LSLog]()
       
        var lastIndex = 0
        for i in 0..<notes.count {
            let note = notes[i]
            let baseScore = lsNotes[i].baseScore
            let comboFactor = lsNotes[i].comboFactor
            var comboBonus = 100
            var perfectBonus = 100
            var skillBoost = 1000
            var baseComboBonus = comboBonus
            var basePerfectBonus = perfectBonus
            let noteRange = LSRange(begin: note.sec - 0.06, length: 0.12)
            
            var firstLoop = true
            var intersectedRanges = [LSRange]()
            var intersectedBonuses = [LSScoreBonus]()
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
                    var subComboBonus = 100
                    var subPerfectBonus = 100
                    var subSkillBoost = 1000
                    
                    for bonus in intersectedBonuses {
                        if bonus.range.contains(range) {
                            switch bonus.type {
                            case .comboBonus, .allRound:
                                subComboBonus = max(subComboBonus, bonus.value)
                            case .perfectBonus, .overload:
                                subPerfectBonus = max(subPerfectBonus, bonus.value)
                            case .skillBoost:
                                subSkillBoost = max(subSkillBoost, bonus.value)
                            case .deep:
                                perfectBonus = Swift.max(perfectBonus, bonus.value)
                                comboBonus = Swift.max(comboBonus, bonus.value2)
                            default:
                                break
                            }
                        }
                    }
                    
                    let subBasePerfectBonus = subPerfectBonus
                    let subBaseComboBonus = subComboBonus
                    
                    if subSkillBoost > 1000 {
                        subPerfectBonus = addSkillBoost(subSkillBoost, to: subPerfectBonus)
                        subComboBonus = addSkillBoost(subSkillBoost, to: subComboBonus)
                    }
                    if (subPerfectBonus * subComboBonus, subSkillBoost) > (perfectBonus * comboBonus, skillBoost) {
                        perfectBonus = subPerfectBonus
                        comboBonus = subComboBonus
                        skillBoost = subSkillBoost
                        basePerfectBonus = subBasePerfectBonus
                        baseComboBonus = subBaseComboBonus
                    }
                }
            }
            
            let score = Int(round(baseScore * comboFactor * Double(perfectBonus * comboBonus) / 10000))
            
            sum += score
            
            if options.contains(.detailLog) {
                let log = LSLog.init(noteIndex: i + 1, score: score, sum: sum, baseScore: baseScore, baseComboBonus: baseComboBonus, comboBonus: comboBonus, basePerfectBonus: basePerfectBonus, perfectBonus: perfectBonus, comboFactor: comboFactor, skillBoost: skillBoost, lifeRestore: 0, currentLife: 0, perfectLock: false, comboContinue: false, guard: false)
                logs.append(log)
            }
        }
        simulateResult.append(sum)
        callback?(LSResult.init(scores: simulateResult), logs)
    }
    
    func simulateOnce(options: LSOptions = [], callback: LSResultClosure? = nil) {
        var sum = 0
        
        var life = totalLife

        var procedBonuses: [LSScoreBonus]
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
        
        // normal simulation
        var lastIndex = 0
        
        let overloadLimitByLife = options.contains(.overloadLimitByLife)
        var overloadedIndexes = [Int]()
        var missedIndexes = [Int]()
    
        for i in 0..<notes.count {
            let note = notes[i]
            let baseScore = lsNotes[i].baseScore
            let comboFactor = lsNotes[i].comboFactor
            var comboBonus = 100
            var perfectBonus = 100
            var skillBoost = 1000
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
                        comboBonus = Swift.max(comboBonus, bonus.value)
                    case .deep:
                        perfectBonus = Swift.max(perfectBonus, bonus.value)
                        comboBonus = Swift.max(comboBonus, bonus.value2)
                    case .allRound:
                        comboBonus = Swift.max(comboBonus, bonus.value)
                        restoreLife += bonus.value2
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
                        perfectBonus = Swift.max(perfectBonus, bonus.value)
                    case .skillBoost:
                        skillBoost = Swift.max(skillBoost, bonus.value)
                    case .heal:
                        restoreLife = Swift.max(restoreLife, bonus.value)
                    case .comboContinue:
                        comboContinue = true
                    case .perfectLock:
                        perfectLock = true
                    case .guard:
                        damageGuard = true
                    }
                }
            }
            
        
            let baseComboBonus = comboBonus
            let basePerfectBonus = perfectBonus
            
            if skillBoost > 1000 {
                perfectBonus = addSkillBoost(skillBoost, to: perfectBonus)
                comboBonus = addSkillBoost(skillBoost, to: comboBonus)
                if restoreLife != 0 {
                    restoreLife += 1
                }
            }
            
            life = min(totalLife, life + restoreLife)
            
            let score = Int(round(baseScore * comboFactor * Double(perfectBonus * comboBonus) / 10000))
            
            sum += score
            
            if options.contains(.detailLog) {
                let log = LSLog(noteIndex: i + 1, score: score, sum: sum, baseScore: baseScore, baseComboBonus: baseComboBonus, comboBonus: comboBonus, basePerfectBonus: basePerfectBonus, perfectBonus: perfectBonus, comboFactor: comboFactor, skillBoost: skillBoost, lifeRestore: restoreLife, currentLife: life, perfectLock: perfectLock, comboContinue: comboContinue, guard: damageGuard)
                logs.append(log)
            }

        }
        
        simulateResult.append(sum)
        callback?(LSResult.init(scores: simulateResult), logs)
        
//        #if DEBUG
//            let arr = scores.map { $0.toDictionary }
//            let json = JSON(arr)
//            try? json.rawString()?.write(toFile: NSHomeDirectory() + "/test.txt", atomically: true, encoding: .utf8)
//        #endif
    }
    
    private func addSkillBoost(_ skillBoost: Int, to bonus: Int) -> Int {
        return 100 + Int(ceil(Double((bonus - 100) * skillBoost) * 0.001))
    }
    
    func wipeResults() {
        simulateResult.removeAll()
    }

    func simulate(times: UInt, callback: @escaping LSResultClosure) {
        simulate(times: times, progress: { _,_ in }, callback: callback)
    }
    
    func simulate(times: UInt, progress: CGSSProgressClosure, callback: @escaping LSResultClosure) {
        for i in 0..<times {
            simulateOnce(options: .overloadLimitByLife)
            progress(Int(i + 1), Int(times))
        }
        let result = LSResult.init(scores: simulateResult)
        callback(result, [])
    }
}

