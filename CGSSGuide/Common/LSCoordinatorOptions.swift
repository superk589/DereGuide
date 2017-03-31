//
//  LSCoordinatorOptions.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct LSCoordinatorOptions: OptionSet {
    let rawValue:UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let perfectTolerence = LSCoordinatorOptions.init(rawValue: 1 << 0)
}
