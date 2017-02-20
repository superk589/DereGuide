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
    var procChance: Float {
        return skill.procChanceOfLevel(level)
    }
    var effectLength: Float {
        return skill.effectLengthOfLevel(level)
    }
    
    var explainRanked: String {
        var explain = skill.explainEn!
        let subs = explain.match(pattern: "[0-9.]+ ~ [0-9.]+")
        let sub1 = subs[0]
        let range1 = explain.range(of: sub1 as String)
        explain.replaceSubrange(range1!, with: String(format: "%.2f", skill.procChanceOfLevel(level)))
        let sub2 = subs[1]
        let range2 = explain.range(of: sub2 as String)
        explain.replaceSubrange(range2!, with: String(format: "%.2f", skill.effectLengthOfLevel(level)))
        return explain
    }
    
    func getUpRanges(lastNoteSec sec: Double) -> [ScoreUpRange] {
        let condition: Int = skill.condition
        // 最后一个note的前三秒不再触发新的技能
        let count = Int(ceil((sec - 3) / Double(condition)))
        var ranges = [ScoreUpRange]()
        for i in 0..<count {
            // 第一个触发区间内不触发技能
            if i == 0 { continue }
            let range = ScoreUpRange(begin: Double(i * condition), length: Double(effectLength))
            ranges.append(range)
        }
        return ranges
    }
    
}
