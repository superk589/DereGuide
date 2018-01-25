//
//  EventRankingSpeed.swift
//  DereGuide
//
//  Created by zzk on 2017/1/24.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

struct EventRankingSpeed {
    
    private var _storage: [Int: Int]
    
    
    init(_ speeds: [Int: Int]) {
        self._storage = speeds
    }
    
    subscript (border: Int) -> Int {
        return _storage[border] ?? 0
    }
}
