//
//  CGSSLiveFormulator.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/18.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

extension LSNote {
    func expectation(in distribution: LFDistribution) -> Double {
        
        //先对离散分布的每种情况进行分别取整 再做单个note的得分期望计算
        let expectation = distribution.samples.reduce(0.0) { $0 + round(baseScore * comboFactor * Double($1.value.bonusValue) / 10000) * $1.probability }
        
        return expectation
    }
}

/// Formulator is only used in optimistic score 2 and average score calculation
class CGSSLiveFormulator {
    
    var notes: [LSNote]
    var bonuses: [LSSkill]
    
    lazy var distributions: [LFDistribution] = {
        return self.generateScoreDistributions()
    }()
    
    init(notes: [LSNote], bonuses: [LSSkill]) {
        self.bonuses = bonuses
        self.notes = notes
    }
    
    var averageScore: Int {
//        var scores = [Int]()
        var sum = 0.0
        for i in 0..<notes.count {
            let note = notes[i]
            let distribution = distributions[i]
            sum += note.expectation(in: distribution)
//            scores.append(Int(round(note.baseScore * note.comboFactor * distribution.average / 10000)))
        }
//        (scores as NSArray).write(to: URL.init(fileURLWithPath: NSHomeDirectory() + "/new.txt"), atomically: true)
        return Int(round(sum))
    }
    
    var maxScore: Int {
        var sum = 0
        for i in 0..<notes.count {
            let note = notes[i]
            let distribution = distributions[i]
            sum += Int(round(note.baseScore * note.comboFactor * Double(distribution.max) / 10000))
        }
        return sum
    }
    
    private func generateScoreDistributions() -> [LFDistribution] {
        var distributions = [LFDistribution]()
        for i in 0..<notes.count {
            let note = notes[i]
            
            let validBonuses = bonuses.filter { $0.range.contains(note.sec) }
            
            var samples = [LFSamplePoint<LSScoreBonusGroup>]()

    
            for mask in 0..<(1 << validBonuses.count) {
                var bonusGroup = LSScoreBonusGroup.basic
                var p = 1.0
                for j in 0..<validBonuses.count {
                    let bonus = validBonuses[j]
                    if mask & (1 << j) != 0 {
                        p *= bonus.probability
                        switch bonus.type {
                        case .comboBonus, .allRound:
                            bonusGroup.baseComboBonus = max(bonusGroup.baseComboBonus, bonus.value)
                        case .perfectBonus, .overload:
                            bonusGroup.basePerfectBonus = max(bonusGroup.basePerfectBonus, bonus.value)
                        case .skillBoost:
                            bonusGroup.skillBoost = max(bonusGroup.skillBoost, bonus.value)
                        case .deep:
                            bonusGroup.basePerfectBonus = max(bonusGroup.basePerfectBonus, bonus.value)
                            bonusGroup.baseComboBonus = max(bonusGroup.baseComboBonus, bonus.value2)
                        default:
                            break
                        }
                    } else {
                        p *= 1 - bonus.probability
                    }
                    
                }
                let sample = LFSamplePoint<LSScoreBonusGroup>.init(probability: p, value: bonusGroup)
                samples.append(sample)
            }
            
            let distribution = LFDistribution(samples: samples)
            distributions.append(distribution)
        
        }
        return distributions
    }
}
