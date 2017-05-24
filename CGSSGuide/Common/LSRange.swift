//
//  LSRange.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct LSRange {
    var begin: Float
    var length: Float
    
    var end: Float {
        return begin + length
    }
    
    func contains(_ sec: Float) -> Bool {
        return sec >= begin && sec <= end
    }
    
    func contains(_ subRange: LSRange) -> Bool {
        return begin <= subRange.begin && end >= subRange.end
    }
    
    func intersects(_ otherRange: LSRange) -> Bool {
        return contains(otherRange.begin) || contains(otherRange.end) || otherRange.contains(self)
    }
    
    func intersection(_ otherRange: LSRange) -> LSRange? {
        
        guard intersects(otherRange) else {
            return nil
        }

        var begin = self.begin
        var end = self.end
        if contains(otherRange.begin) {
            begin = otherRange.begin
        }
        if contains(otherRange.end) {
            end = otherRange.end
        }
        
        let newRange = LSRange.init(begin: begin, length: end - begin)
        
        // notice that length may be zero, due to float accuracy problem, even though end != begin
        return newRange
    }
}


extension CGSSRankedSkill {
    func getUpRanges(lastNoteSec sec: Float) -> [LSRange] {
        let condition: Int = skill.condition
        // 最后一个note的前三秒不再触发新的技能
        let count = Int(ceil((sec - 3) / Float(condition)))
        var ranges = [LSRange]()
        for i in 0..<count {
            // 第一个触发区间内不触发技能
            if i == 0 { continue }
            let range = LSRange(begin: Float(i * condition), length: Float(length) / 100)
            ranges.append(range)
        }
        return ranges
    }
}
