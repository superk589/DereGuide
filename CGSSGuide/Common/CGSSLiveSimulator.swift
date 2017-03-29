//
//  CGSSLiveSimulator.swift
//  CGSSGuide
//
//  Created by zzk on 2017/2/19.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias SimulateResultClosure = (SimulateResult) -> Void

struct SimulateResult {
    var scores: [Int]
    
    var avg: Int {
        return scores.reduce(0, +) / scores.count
    }
    
    init(scores: [Int]) {
        self.scores = scores.sorted(by: >)
    }
    
    func get(percent: Int) -> Int {
        let index = percent * scores.count / 100
        return scores[index - 1]
    }
}

struct LiveSimulatorOptions: OptionSet {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let maxRate = LiveSimulatorOptions.init(rawValue: 1 << 0)
    static let detailLog = LiveSimulatorOptions.init(rawValue: 1 << 1)
}

class CGSSLiveSimulator {
    
    var distributions: [ScoreDistribution]
    var contents: [ScoreUpContent]
    var notes: [CGSSBeatmapNote]
    
    init(distributions: [ScoreDistribution], contents: [ScoreUpContent], notes: [CGSSBeatmapNote]) {
        self.distributions = distributions
        self.contents = contents
        self.notes = notes
    }
    
    var average: Int {
        return distributions.reduce(0, { $0 + $1.average })
    }
    
    var max: Int {
        return distributions.reduce(0, { $0 + $1.max })
    }
    
    
    func expectationsOfRate(rate: Float) -> Int {
        return 0
    }
    
    var simulateResult = [Int]()
    
    func simulateOnce(options: LiveSimulatorOptions = [], callback: (([NoteScoreDetail]) -> Void)? = nil) {
        var sum = 0
        var procedContents = [ScoreUpContent]()
        for content in contents {
            if options.contains(.maxRate) || CGSSGlobal.isProc(rate: Int(round(content.rate * 100000))) {
                procedContents.append(content)
            }
        }
        
        procedContents.sort { $0.range.begin < $1.range.begin }
        
        var logs = [NoteScoreDetail]()
        
        for i in 0..<notes.count {
            let note = notes[i]
            let baseScore = distributions[i].baseScore
            let comboFactor = distributions[i].comboFactor
            var comboBonus = 100
            var perfectBonus = 100
            var skillBoost = 1000
            
            for content in procedContents {
                if note.sec > content.range.end {
                    continue
                } else if note.sec < content.range.begin {
                    break
                } else {
                    switch content.upType {
                    case ScoreUpTypes.comboBonus:
                        if content.upValue > comboBonus {
                            comboBonus = content.upValue
                        }
                    case ScoreUpTypes.perfectBonus:
                        if content.upValue > perfectBonus {
                            perfectBonus = content.upValue
                        }
                    case ScoreUpTypes.skillBoost:
                        if content.upValue > skillBoost {
                            skillBoost = content.upValue
                        }
                    default:
                        break
                    }
                }
            }
        
            let baseComboBonus = comboBonus
            let basePerfectBonus = perfectBonus
            
            if skillBoost > 1000 {
                perfectBonus = 100 + Int(ceil(Float((perfectBonus - 100) * skillBoost) * 0.001))
                comboBonus = 100 + Int(ceil(Float((comboBonus - 100) * skillBoost) * 0.001))
            }
            
            let score = Int(round(baseScore * comboFactor * Float(perfectBonus * comboBonus) / 10000))
            
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
    
    func wipeSimulatorResults() {
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
        let result = SimulateResult.init(scores: simulateResult)
        callback(result)
    }
}

