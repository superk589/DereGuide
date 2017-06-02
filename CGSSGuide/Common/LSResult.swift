//
//  LSResult.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct LSResult {
    
    let scores: [Int]
    
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
    
    var maxScore: Int {
        return scores.max() ?? 0
    }
    
    var minScore: Int {
        return scores.min() ?? 0
    }
    
}


// kernel density estimation
extension LSResult {
    
    typealias KernelFunction = (Double, Double) -> Double
    
    struct Kernel {
        
        static let uniform: KernelFunction = { (x: Double, h: Double) in
            if abs(x) <= h {
                return uniformUnchecked(x, h)
            } else {
                return 0
            }
        }
        
        static let uniformUnchecked: KernelFunction = { (x: Double, h: Double) in
            return 1 / 2 / h
        }

        static let gaussian: KernelFunction = { (x: Double, h: Double) in
            return 1 / sqrt(2 * Double.pi) * pow(M_E, -1 / 2 * (x / h) * (x / h)) / h
        }
        
        static let triangular: KernelFunction = { (x: Double, h: Double) in
            if abs(x) <= h {
                return triangularUnchecked(x, h)
            } else {
                return 0
            }
        }
        
        static let triangularUnchecked: KernelFunction = { (x: Double, h: Double) in
            return (1 - abs(x / h)) / h
        }
        
    }

    var reversed: [Int] {
        return scores.reversed()
    }
    
    var h: Double {
        return 4 * Double(maxScore - minScore) / sqrt(Double(scores.count))
    }
    
}
