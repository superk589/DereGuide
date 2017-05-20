//
//  LFDistribution.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

/// only used in live formulator
struct LFDistribution {
    
    var samples: [LFSamplePoint<LSScoreBonusGroup>]
    
    var average: Double {
        if samples.count == 0 {
            return Double(LSScoreBonusGroup.basic.bonusValue)
        } else {
            return samples.reduce(0.0, {$0 + Double($1.value.bonusValue) * $1.probability})
        }
    }
    
    var max: Int {
        let max = samples.max {
            $0.value.bonusValue < $1.value.bonusValue
        }
        if let max = max {
            return max.value.bonusValue
        } else {
            return LSScoreBonusGroup.basic.bonusValue
        }
    }
}

