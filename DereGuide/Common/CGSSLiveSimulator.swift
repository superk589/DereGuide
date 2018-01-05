//
//  CGSSLiveSimulator.swift
//  DereGuide
//
//  Created by zzk on 2017/2/19.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias LSResultClosure = (LSResult, [LSLog]) -> Void

class CGSSLiveSimulator {
    
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
        var sum = 0
        
//        let sortedBonuses = bonuses.sorted { $0.range.begin < $1.range.begin }
        
        var logs = [LSLog]()
       
        for i in 0..<notes.count {
            let note = notes[i]
            let baseScore = note.baseScore
            let comboFactor = note.comboFactor
            var bonusGroup = LSScoreBonusGroup.basic
            let radius = perfectRadius[difficulty]![note.rangeType]!
            let concentratedRadius = concentratedPerfectRadius[difficulty]![note.rangeType]!
            let noteRange = LSRange(begin: note.sec - radius, length: 2 * radius)
            let noteConcentratedRange = LSRange(begin: note.sec - concentratedRadius, length: concentratedRadius * 2)
            
            var intersectedRanges = [LSRange]()
            var intersectedBonuses = [LSSkill]()
            for bonus in bonuses {
                if bonus.isConcentrated {
                    if note.sec - concentratedRadius <= bonus.range.end || note.sec + concentratedRadius >= bonus.range.begin {
                        if let intersectedRange = bonus.range.intersection(noteConcentratedRange) {
                            intersectedRanges.append(intersectedRange)
                        }
                        intersectedBonuses.append(bonus)
                    }
                } else {
                    if note.sec - radius <= bonus.range.end || note.sec + radius >= bonus.range.begin {
                        if let intersectedRange = bonus.range.intersection(noteRange) {
                            intersectedRanges.append(intersectedRange)
                        }
                        intersectedBonuses.append(bonus)
                    }
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
                            case .perfectBonus, .overload, .concentration:
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

        // all proc skills
        var procedBonuses = bonuses
            .sorted { $0.range.begin < $1.range.begin }
            .filter {
                options.contains(.maxRate) || CGSSGlobal.isProc(rate: Int(round($0.rate * Double(100 + $0.rateBonus) / 10)))
            }
        
        // replace all encore skills by last skill
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
                        bonusGroup.baseComboBonus = max(bonusGroup.baseComboBonus, comboBonusValueOfLife(life))
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
    
    
    
    func wipeResults() {
        simulateResult.removeAll()
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

fileprivate let lifeToComboBonus: [Int: Int] = [
    0: 108,
    10: 108,
    20: 108,
    30: 108,
    40: 108,
    50: 109,
    60: 109,
    70: 109,
    80: 109,
    90: 109,
    100: 110,
    110: 110,
    120: 110,
    130: 110,
    140: 110,
    150: 111,
    160: 111,
    170: 111,
    180: 111,
    190: 112,
    200: 112,
    210: 112,
    220: 112,
    230: 112,
    240: 113,
    250: 113,
    260: 113,
    270: 113,
    280: 113,
    290: 114,
    300: 114,
    310: 114,
    320: 114,
    330: 114,
    340: 115,
    350: 115,
    360: 115,
    370: 115,
    380: 116,
    390: 116,
    400: 116,
    410: 116,
    420: 116,
    430: 117,
    440: 117,
    450: 117,
    460: 117,
    470: 117,
    480: 118,
    490: 118,
    500: 118,
    510: 118,
    520: 118,
    530: 119,
    540: 119,
    550: 119,
    560: 119,
    570: 120,
    580: 120,
    590: 120,
    600: 120,
    610: 120,
    620: 121,
    630: 121,
    640: 121,
    650: 121,
    660: 121,
    670: 122,
    680: 122,
    690: 122,
    700: 122,
    710: 122,
    720: 123,
    730: 123,
    740: 123,
    750: 123,
    760: 124,
    770: 124,
    780: 124,
    790: 124,
    800: 124,
    810: 125,
    820: 125,
    830: 125,
    840: 125,
    850: 125,
    860: 126,
    870: 126,
    880: 126,
    890: 126,
    900: 126,
    910: 127,
    920: 127,
    930: 127,
    940: 127,
    950: 128,
    960: 128,
    970: 128,
    980: 128,
    990: 128,
    1000: 129,
    1010: 129,
    1020: 129,
    1030: 129,
    1040: 129,
    1050: 130,
    1060: 130,
    1070: 130,
    1080: 130,
    1090: 130,
    1100: 131,
    1110: 131,
    1120: 131,
    1130: 131,
    1140: 132,
    1150: 132,
    1160: 132,
    1170: 132,
    1180: 132,
    1190: 133,
    1200: 133,
    1210: 133,
    1220: 133,
    1230: 133,
    1240: 134,
    1250: 134,
    1260: 134,
    1270: 134,
    1280: 134,
    1290: 135,
    1300: 135,
    1310: 135,
    1320: 135,
    1330: 136,
    1340: 136,
    1350: 136,
    1360: 136,
    1370: 136,
    1380: 137,
    1390: 137,
    1400: 137,
    1410: 137,
    1420: 137,
    1430: 138,
    1440: 138,
    1450: 138,
    1460: 138,
    1470: 138,
    1480: 139,
    1490: 139,
    1500: 139,
    1510: 139,
    1520: 140,
    1530: 140,
    1540: 140,
    1550: 140,
    1560: 140,
    1570: 141,
    1580: 141,
    1590: 141,
    1600: 141
]


private func comboBonusValueOfLife(_ life: Int) -> Int {
    let key = life / 10 * 10
    return lifeToComboBonus[key] ?? 108
}


private extension Int {
    func addGreatPercent(_ percent: Double) -> Int {
        return Int(round(Double(self) * (1 - 0.3 * percent / 100)))
    }
}

