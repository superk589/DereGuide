//
//  LSOptions.swift
//  DereGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation

struct LSOptions: OptionSet {
    let rawValue: UInt
    
    init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    /// all procs are assumed to be 100% triggered
    static let optimistic = LSOptions(rawValue: 1 << 0)
    
    /// generate detail logs of each note in the format of LSLog
    static let detailLog = LSOptions(rawValue: 1 << 1)
    
    /// in afk mode, all notes are assumed to be missed
    static let afk = LSOptions(rawValue: 1 << 2)
    
    /// all procs are assumed to be not triggered unless it has an 100% proc rate. If optimistic is set, this option will not work. If both are not set, skill will proc randomly based on its real rate.
    static let pessimistic = LSOptions(rawValue: 1 << 3)

    /// start live with double hp
    static let doubleHP = LSOptions(rawValue: 1 << 4)
}
