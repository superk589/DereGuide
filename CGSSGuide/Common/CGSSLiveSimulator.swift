//
//  CGSSLiveSimulator.swift
//  CGSSGuide
//
//  Created by zzk on 2017/2/19.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias SimulateResultClosure = (LSResult) -> Void

class CGSSLiveSimulator {
    
    var lsNotes: [LSNote]
    var bonuses: [LSScoreBonus]
    var notes: [CGSSBeatmapNote]
    
    init(distributions: [LSNote], bonuses: [LSScoreBonus], notes: [CGSSBeatmapNote]) {
        self.lsNotes = distributions
        self.bonuses = bonuses
        self.notes = notes
    }
    
    var average: Int {
        return lsNotes.reduce(0, { $0 + $1.average })
    }
    
    var max: Int {
        return lsNotes.reduce(0, { $0 + $1.max })
    }
    
    
    func expectationsOfRate(rate: Float) -> Int {
        return 0
    }
    
    var simulateResult = [Int]()
    
    func simulateOnce(options: LSOptions = [], callback: (([NoteScoreDetail]) -> Void)? = nil) {
        var sum = 0
        var procedBonuses = [LSScoreBonus]()
        for bonus in bonuses {
            if options.contains(.maxRate) || CGSSGlobal.isProc(rate: Int(round(bonus.rate * Double(100 + bonus.rateBonus) / 10))) {
                procedBonuses.append(bonus)
            }
        }
        
        procedBonuses.sort { $0.range.begin < $1.range.begin }
        
        var logs = [NoteScoreDetail]()
        
        var lastIndex = 0
        for i in 0..<notes.count {
            let note = notes[i]
            let baseScore = lsNotes[i].baseScore
            let comboFactor = lsNotes[i].comboFactor
            var comboBonus = 100
            var perfectBonus = 100
            var skillBoost = 1000
            
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
                    case LSScoreBonusTypes.comboBonus:
                        if bonus.value > comboBonus {
                            comboBonus = bonus.value
                        }
                    case LSScoreBonusTypes.perfectBonus:
                        if bonus.value > perfectBonus {
                            perfectBonus = bonus.value
                        }
                    case LSScoreBonusTypes.skillBoost:
                        if bonus.value > skillBoost {
                            skillBoost = bonus.value
                        }
                    default:
                        break
                    }
                }
            }
        
            let baseComboBonus = comboBonus
            let basePerfectBonus = perfectBonus
            
            if skillBoost > 1000 {
                perfectBonus = 100 + Int(ceil(Double((perfectBonus - 100) * skillBoost) * 0.001))
                comboBonus = 100 + Int(ceil(Double((comboBonus - 100) * skillBoost) * 0.001))
            }
            
            let score = Int(round(baseScore * comboFactor * Double(perfectBonus * comboBonus) / 10000))
            
            sum += score
            
            if options.contains(.detailLog) {
                let socreDetail = NoteScoreDetail.init(noteIndex: i + 1, score: score, sum: sum, baseScore: baseScore, baseComboBonus: baseComboBonus, comboBonus: comboBonus, basePerfectBonus: basePerfectBonus, perfectBonus: perfectBonus, comboFactor: comboFactor, skillBoost: skillBoost)
                logs.append(socreDetail)
            }
        }
        simulateResult.append(sum)
        callback?(logs)
        
//        #if DEBUG
//            let arr = scores.map { $0.toDictionary }
//            let json = JSON(arr)
//            try? json.rawString()?.write(toFile: NSHomeDirectory() + "/test.txt", atomically: true, encoding: .utf8)
//        #endif
    }
    
    func wipeResults() {
        simulateResult.removeAll()
    }

    func simulate(times: UInt, callback: @escaping SimulateResultClosure) {
        simulate(times: times, progress: { _,_ in }, callback: callback)
    }
    
    func simulate(times: UInt, progress: CGSSProgressClosure, callback: @escaping SimulateResultClosure) {
        for i in 0..<times {
            simulateOnce()
            progress(Int(i + 1), Int(times))
        }
        let result = LSResult.init(scores: simulateResult)
        callback(result)
    }
}

