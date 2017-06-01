//
//  LSResult.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct LSResult {
    
    var scores: [Int]
    
    var average: Int {
        return scores.reduce(0, +) / scores.count
    }
    
    init(scores: [Int]) {
        self.scores = scores.sorted(by: >)
    }
    
    func get(percent: Int) -> Int {
        let index = percent * scores.count / 100
        guard index > 0 else {
            return scores[0]
        }
        return scores[index - 1]
    }
}
