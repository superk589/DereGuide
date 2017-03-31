//
//  LSDistribution.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct LSDistribution {
    
    var samples: [LSSamplePoint<Int>]
    
    var average: Double? {
        guard samples.count > 0 else {
            return nil
        }
        return samples.reduce(0.0, {$0 + Double($1.value) * $1.probability})
    }
    
    var max: Int? {
        guard let v = samples.first else {
            return nil
        }
        return v.value
    }
    
    init(_ bonuses: [LSScoreBonus], defaultValue: Int = 100) {
        let sortedBonuses = bonuses.sorted(by: { $0.value > $1.value })
        var samples = [LSSamplePoint<Int>]()
        var leftRate: Double = 100
        for i in 0..<sortedBonuses.count {
            let bonus = sortedBonuses[i]
            let s = LSSamplePoint<Int>.init(probability: leftRate * bonus.probability / 100, value: bonus.value)
            samples.append(s)
            leftRate -= leftRate * bonus.probability
        }
        samples.append(LSSamplePoint<Int>.init(probability: leftRate / 100, value: defaultValue))
        self.samples = samples
    }
    
    init(samples: [LSSamplePoint<Int>]) {
        self.samples = samples
    }
    
    func addSkillBoostDistribution(_ skillBoostDistribution: LSDistribution) -> LSDistribution {
        guard skillBoostDistribution.samples.count > 1 else {
            return self
        }
        var newSamples = [LSSamplePoint<Int>]()
        for v in samples {
            var leftRate: Double = 100
            for s in skillBoostDistribution.samples {
                let value = Int(ceil(Float((v.value - 100) * s.value) * 0.001)) + 100
                let rate = leftRate * s.probability * v.probability / 100
                newSamples.append(LSSamplePoint<Int>.init(probability: rate, value: value))
                leftRate -= leftRate * s.probability
            }
            newSamples.append(LSSamplePoint<Int>.init(probability: leftRate * v.probability / 100, value: v.value))
        }
        return LSDistribution.init(samples: newSamples)
    }
}

