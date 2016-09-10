//
//  CGSSRankedSkill.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/8.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSRankedSkill: NSObject {
    
    var level: Int!
    var skill: CGSSSkill!
    
    init(skill: CGSSSkill, level: Int) {
        self.level = level
        self.skill = skill
    }
    var procChance: Float? {
        return skill.procChanceOfLevel(level)
    }
    var effectLength: Float? {
        return skill.effectLengthOfLevel(level)
    }
    
    var explainRanked: String {
        var explain = skill.explainEn
        let pattern = "[0-9.]+ ~ [0-9.]+"
        let subs = CGSSGlobal.getStringByPattern(explain, pattern: pattern)
        let sub1 = subs[0]
        let range1 = explain.rangeOfString(sub1 as String)
        explain.replaceRange(range1!, with: String(format: "%.2f", skill.procChanceOfLevel(level)!))
        let sub2 = subs[1]
        let range2 = explain.rangeOfString(sub2 as String)
        explain.replaceRange(range2!, with: String(format: "%.2f", skill.effectLengthOfLevel(level)!))
        return explain
    }
    
    func getRangesOfProc(sec: Float, procMax: Bool, upValue: Int = 0) -> [(Float, Float)] {
        let count = Int(ceil(sec / Float(skill.condition!)))
        var procArr = [(Float, Float)]()
        for i in 1..<count {
            if CGSSGlobal.isProc(procMax ? 100000 : Int(round(procChance! * Float(100 + upValue) * 10))) {
                procArr.append((Float(i * skill.condition!), Float(i * skill.condition!) + effectLength!))
            }
        }
        return procArr
    }
    
}
