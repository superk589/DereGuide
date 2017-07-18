//
//  GachaSimulationResult.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/18.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct GachaSimulationResult {
        
    var times: Int
    var ssrCount: Int
    var srCount: Int
    
    var rCount: Int {
        return times - ssrCount - srCount
    }
    
    var jewel: Int {
        return 250 * times
    }
    
    var ssrRate: Double {
        return Double(ssrCount) / Double(times)
    }
    
    var srRate: Double {
        return Double(srCount) / Double(times)
    }
    
    var rRate: Double {
        return Double(rCount) / Double(times)
    }
    
    static func + (lhs: GachaSimulationResult, rhs: GachaSimulationResult) -> GachaSimulationResult {
        return GachaSimulationResult(times: lhs.times + rhs.times, ssrCount: lhs.ssrCount + rhs.ssrCount, srCount: lhs.srCount + rhs.srCount)
    }
    
    static func += (lhs: inout GachaSimulationResult, rhs: GachaSimulationResult) {
        lhs.times += rhs.times
        lhs.ssrCount += rhs.ssrCount
        lhs.srCount += rhs.srCount
    }
}
