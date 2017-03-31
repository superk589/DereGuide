//
//  LSOptions.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct LSOptions: OptionSet {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let maxRate = LSOptions.init(rawValue: 1 << 0)
    static let detailLog = LSOptions.init(rawValue: 1 << 1)
}
