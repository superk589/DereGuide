//
//  CGSSLiveSimulator.swift
//  CGSSGuide
//
//  Created by zzk on 2017/2/19.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

typealias SimulateResultClosure = (SimulateResult) -> Void

struct SimulateResult {
    var scores: [Int]
    
    var avg: Int {
        return scores.reduce(0, { $0 + $1 }) / scores.count
    }
    
    init(scores: [Int]) {
        self.scores = scores.sorted(by: >)
    }
    
    func get(percent: Int) -> Int {
        let index = percent * scores.count / 100
        return scores[index]
    }
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
        var sum = 0
        for distribution in distributions {
            sum += distribution.average
        }
        return sum
    }
    
    var max: Int {
        var sum = 0
        for distribution in distributions {
            sum += distribution.max
        }
        return sum
    }
    
    
    func expectationsOfRate(rate: Float) -> Int {
        return 0
    }
    
    var simulateResult = [Int]()
    
    func simulateOnce() {
        var sum = 0
        var procedContents = [ScoreUpContent]()
        for content in contents {
            if CGSSGlobal.isProc(rate: Int(content.rate * 100000)) {
                procedContents.append(content)
            }
        }
        
        for i in 0..<notes.count {
            let note = notes[i]
            let baseScore = distributions[i].baseScore
            let comboFactor = distributions[i].comboFactor
            var comboBonus = 100
            var perfectBonus = 100
            var skillBoost = 1000

            for content in procedContents {
                if note.sec >= content.range.begin && note.sec <= content.range.end {
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
            sum += Int(round(baseScore * comboFactor * Float(perfectBonus * comboBonus) / 10000))
        }
        simulateResult.append(sum)
    }
    func simulate(times: UInt, callback: @escaping SimulateResultClosure) {
        for _ in 0..<times {
            simulateOnce()
        }
        let result = SimulateResult.init(scores: simulateResult)
        DispatchQueue.main.async {
            callback(result)
        }
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

