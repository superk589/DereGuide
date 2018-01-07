//
//  LSRange.swift
//  DereGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct LSRange<Bound: Comparable & Numeric> {
    
    var begin: Bound
    var end: Bound
    
    init(begin: Bound, length: Bound) {
        assert(length >= 0)
        self.init(begin: begin, end: begin + length)
    }
    
    init(begin: Bound, end: Bound) {
        assert(end >= begin)
        self.begin = begin
        self.end = end
    }
    
    var length: Bound {
        return end - begin
    }
    
    func contains(_ value: Bound) -> Bool {
        return value >= begin && value < end
    }
    
    func contains(_ otherRange: LSRange<Bound>) -> Bool {
        return begin <= otherRange.begin && end >= otherRange.end
    }
    
    func intersects(_ otherRange: LSRange<Bound>) -> Bool {
        return contains(otherRange.begin) || contains(otherRange.end) || otherRange.contains(self)
    }
    
    func intersection(_ otherRange: LSRange<Bound>) -> LSRange<Bound>? {
        
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
        
        // notice that length may be zero, due to float accuracy problem, even though end != begin
        return LSRange(begin: begin, end: end)
    }
    
    func subtract(_ otherRange: LSRange<Bound>) -> [LSRange<Bound>] {
        
        if !intersects(otherRange) || otherRange.contains(self) {
            return [self]
        }
        
        var ranges = [LSRange<Bound>]()
        
        if begin < otherRange.begin {
            ranges.append(LSRange(begin: begin, end: otherRange.begin))
        }
        
        if end > otherRange.end {
            ranges.append(LSRange(begin: otherRange.end, end: end))
        }
        
        return ranges
    }
}

extension LSRange: Equatable {
    
    static func ==(lhs: LSRange<Bound>, rhs: LSRange<Bound>) -> Bool {
        return lhs.begin == rhs.begin && lhs.end == rhs.end
    }
    
}


extension CGSSRankedSkill {
    func getUpRanges(lastNoteSec sec: Float) -> [LSRange<Float>] {
        let condition: Int = skill.condition
        // 最后一个note的前三秒不再触发新的技能
        let count = Int(ceil((sec - 3) / Float(condition)))
        var ranges = [LSRange<Float>]()
        for i in 0..<count {
            // 第一个触发区间内不触发技能
            if i == 0 { continue }
            let range = LSRange(begin: Float(i * condition), length: Float(length) / 100)
            ranges.append(range)
        }
        return ranges
    }
}
