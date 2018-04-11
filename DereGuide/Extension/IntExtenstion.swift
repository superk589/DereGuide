//
//  IntExtenstion.swift
//  DereGuide
//
//  Created by zzk on 2018/4/14.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

extension Int {
    
    func proc(_ odds: Int) -> Bool {
        let random = arc4random_uniform(UInt32(self))
        return odds > Int(random)
    }
}

extension UInt32 {
    
    func proc(_ odds: Int) -> Bool {
        let random = arc4random_uniform(self)
        return odds > Int(random)
    }
}
