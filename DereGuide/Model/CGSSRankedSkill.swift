//
//  CGSSRankedSkill.swift
//  DereGuide
//
//  Created by zzk on 16/8/8.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

struct CGSSRankedSkill {
    
    var level: Int
    var skill: CGSSSkill
    
    var chance: Int {
        return skill.procChanceOfLevel(level)
    }
    var length: Int {
        return skill.effectLengthOfLevel(level)
    }
    
    var explainRanked: String {
        var explain = skill.explainEn!
        let subs = explain.match(pattern: "[0-9.]+ ~ [0-9.]+")
        let sub1 = subs[0]
        let range1 = explain.range(of: sub1 as String)
        explain.replaceSubrange(range1!, with: String(format: "%@", (Decimal(skill.procChanceOfLevel(level)) / 100).description))
        let sub2 = subs[1]
        let range2 = explain.range(of: sub2 as String)
        explain.replaceSubrange(range2!, with: String(format: "%@", (Decimal(skill.effectLengthOfLevel(level)) / 100).description))
        return explain
    }
}
