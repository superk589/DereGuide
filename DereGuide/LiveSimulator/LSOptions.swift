//
//  LSOptions.swift
//  DereGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct LSOptions: OptionSet {
    let rawValue: UInt
    
    init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    /// skill proc in maxRate
    static let maxRate = LSOptions.init(rawValue: 1 << 0)
    
    /// generate detail logs of each note in the format of LSLog
    static let detailLog = LSOptions.init(rawValue: 1 << 1)
    
//    static let overloadLimitByLife = LSOptions.init(rawValue: 1 << 2)
    
}
