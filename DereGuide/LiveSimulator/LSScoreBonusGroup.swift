//
//  LSScoreBonusGroup.swift
//  DereGuide
//
//  Created by zzk on 2017/5/19.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

struct LSScoreBonusGroup {
    
    var basePerfectBonus: Int
    var baseComboBonus: Int
    var skillBoost: Int
    
    static let basic = LSScoreBonusGroup(basePerfectBonus: 100, baseComboBonus: 100, skillBoost: 1000)
    
    var bonusValue: Int {
        if skillBoost > 1000 {
            let p = add(skillBoost, to: basePerfectBonus)
            let c = add(skillBoost, to: baseComboBonus)
            return p * c
        } else {
            return basePerfectBonus * baseComboBonus
        }
    }
    
    var comboBonus: Int {
        if skillBoost > 1000 {
            let c = add(skillBoost, to: baseComboBonus)
            return c
        } else {
            return baseComboBonus
        }
    }
    
    var perfectBonus: Int {
        if skillBoost > 1000 {
            let p = add(skillBoost, to: basePerfectBonus)
            return p
        } else {
            return basePerfectBonus
        }

    }
    private func add(_ skillBoost: Int, to bonus: Int) -> Int {
        return 100 + Int(ceil(Double((bonus - 100) * skillBoost) * 0.001))
    }
    
}
