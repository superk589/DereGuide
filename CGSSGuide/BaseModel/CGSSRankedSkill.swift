//
//  CGSSRankedSkill.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/8.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSRankedSkill: NSObject {

    var level:Int!
    var skill:CGSSSkill!
    
    init(skill:CGSSSkill, level:Int) {
        self.level = level
        self.skill = skill
    }
    var procChance:Float? {
        if let p = skill.proc_chance {
            return (Float(p.1! - p.0!) / 9 * (Float(level) - 1) + Float(p.0!)) / 100
        }
        return nil
    }
    var effectLength:Float? {
        if let e = skill.effect_length {
            return (Float(e.1! - e.0!) / 9 * (Float(level) - 1) + Float(e.0!)) / 100
        }
        return nil
    }
    
    var explainRanked:String {
        var explain = skill.explain_en ?? ""
        let pattern =  "[0-9.]+ ~ [0-9.]+"
        let subs = CGSSTool.getStringByPattern(skill.explain_en!, pattern: pattern)
        let sub1 = subs[0]
        let range1 = explain.rangeOfString(sub1 as String)
        explain.replaceRange(range1!, with: String(format: "%.2f",  skill.procChanceOfLevel(level)!))
        let sub2 = subs[1]
        let range2 = explain.rangeOfString(sub2 as String)
        explain.replaceRange(range2!, with: String(format: "%.2f", skill.effectLengthOfLevel(level)!))
        return explain
    }
    
    
    func getRangesOfProc(sec:Float, procMax:Bool) -> [(Float,Float)] {
        let count = Int(ceil(sec / Float(skill.condition!)))
        var procArr = [(Float,Float)]()
        for i in 1..<count {
            if CGSSTool.isProc(procMax ? 10000 : Int(procChance! * 100)) {
                procArr.append((Float(i * skill.condition!), Float(i * skill.condition!) + effectLength!))
            }
        }
        return procArr
    }
    
    
}
