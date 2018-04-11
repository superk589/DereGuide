//
//  LSResult.swift
//  DereGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation

struct LSResult {
    
    let scores: [Int]
    
    let remainedLives: [Int]
    
    var average: Int {
        return scores.reduce(0, +) / scores.count
    }
    
    init(scores: [Int], remainedLives: [Int]) {
        self.scores = scores.sorted(by: >)
        self.remainedLives = remainedLives
    }
    
    func get(percent: Int) -> Int {
        let index = percent * scores.count / 100
        guard index > 0 else {
            return scores[0]
        }
        return scores[index - 1]
    }
    
    func get(percent: Double, _ fromHighToLow: Bool) -> Int {
        if fromHighToLow {
            let index = percent * Double(scores.count) / 100
            guard floor(index) > 0 else {
                return scores[0]
            }
            return scores[Int(floor(index)) - 1]
        } else {
            let reversed = Array(scores.reversed())
            let index = percent * Double(scores.count) / 100
            guard floor(index) > 0 else {
                return reversed[0]
            }
            return reversed[Int(floor(index)) - 1]
        }
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
    
    func estimate(using kernel: KernelFunction, range: Range<Double>, bound: Range<Double>) -> Double {
        let upperBound = min(range.upperBound, bound.upperBound)
        let lowerBound = max(range.lowerBound, bound.lowerBound)
        var result = 0.0
        let h = self.h
        let step = max(1, min(100, (upperBound - lowerBound) / 1000))
        var current = lowerBound
//        var lastIndex = 0
        let scores = self.reversed
        while current <= upperBound {
            var k = 0.0
            for score in scores {
                k += kernel(Double(score) - current, h)
            }
            result += k / Double(scores.count) * step
            current += step
        }
        return result
    }
    
}
