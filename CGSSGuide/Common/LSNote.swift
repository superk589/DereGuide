//
//  LSNote.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct LSNote {
    
    var comboBonusDistribution: LSDistribution
    var perfectBonusDistribution: LSDistribution
    var skillBoostDistribution: LSDistribution
    var comboFactor: Double
    var baseScore: Double
    
    var average: Int {
        let cbAvg = comboBonusDistribution.addSkillBoostDistribution(skillBoostDistribution).average ?? 100
        let pbAvg = perfectBonusDistribution.addSkillBoostDistribution(skillBoostDistribution).average ?? 100
        return Int(round(baseScore * comboFactor * cbAvg * pbAvg / 10000))
    }
    
    var max: Int {
        let cbMax = comboBonusDistribution.addSkillBoostDistribution(skillBoostDistribution).max ?? 100
        let pbMax = perfectBonusDistribution.addSkillBoostDistribution(skillBoostDistribution).max ?? 100
        return Int(round(baseScore * comboFactor * Double(cbMax) * Double(pbMax) / 10000))
    }
}
