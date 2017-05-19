//
//  CGSSLiveFormulator.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/18.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

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
        var sum = 0
        for i in 0..<notes.count {
            let note = notes[i]
            let distribution = distributions[i]
            sum += Int(round(note.baseScore * note.comboFactor * distribution.average / 10000))
        }
        return sum
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
            
            var sorted1 = validBonuses.filter { LSSkillType.allComboBonus.contains($0.type) }.sorted(by: { (s1, s2) -> Bool in
                let value1 = [LSSkillType.deep].contains(s1.type) ? s1.value2 : s1.value
                let value2 = [LSSkillType.deep].contains(s1.type) ? s2.value2 : s2.value
                return value1 > value2
            })
            let range = LSRange(begin: 0, length: 0)
            let baseComboBonus = LSSkill(range: range, value: 100, value2: 100, type: .comboBonus, rate: 10000, rateBonus: 0, triggerLife: 0)
            sorted1.append(baseComboBonus)
            
            var sorted2 = validBonuses.filter { LSSkillType.allPerfectBonus.contains($0.type) }.sorted(by: { (s1, s2) -> Bool in
                let value1 = s1.value
                let value2 = s2.value
                return value1 > value2
            })
            let basePerfectBonus = LSSkill(range: range, value: 100, value2: 100, type: .perfectBonus, rate: 10000, rateBonus: 0, triggerLife: 0)
            sorted2.append(basePerfectBonus)
            
            var sorted3 = validBonuses.filter { $0.type == .skillBoost }.sorted(by: { (s1, s2) -> Bool in
                let value1 = s1.value
                let value2 = s2.value
                return value1 > value2
            })
            let baseSkillBoost = LSSkill(range: range, value: 1000, value2: 100, type: .skillBoost, rate: 10000, rateBonus: 0, triggerLife: 0)
            sorted3.append(baseSkillBoost)
            
            var samples = [LFSamplePoint<LSScoreBonusGroup>]()
            var leftRate: Double = 100
            
            sorted1.forEach({ (s1) in
                if [LSSkillType.deep].contains(s1.type) {
                    var newSorted2 = sorted2.filter { $0.value >= s1.value }
                    var last = s1
                    last.rate = 10000
                    newSorted2.append(last)
                    newSorted2.forEach({ (s2) in
                        sorted3.forEach({ (s3) in
                            let probability = s1.probability * s2.probability * s3.probability
                            let point = LFSamplePoint<LSScoreBonusGroup>.init(probability: leftRate * probability / 100, value: LSScoreBonusGroup(basePerfectBonus: s2.value, baseComboBonus: s1.value2, skillBoost: s3.value))
                            samples.append(point)
                            leftRate -= leftRate * probability
                        })
                    })
                } else {
                    sorted2.forEach({ (s2) in
                        sorted3.forEach({ (s3) in
                            let probability = s1.probability * s2.probability * s3.probability
                            let point = LFSamplePoint<LSScoreBonusGroup>.init(probability: leftRate * probability / 100, value: LSScoreBonusGroup(basePerfectBonus: s2.value, baseComboBonus: s1.value, skillBoost: s3.value))
                            samples.append(point)
                            leftRate -= leftRate * probability
                        })
                    })
                }
            })
           let distribution = LFDistribution(samples: samples)
            distributions.append(distribution)
        }
        return distributions
    }
}
