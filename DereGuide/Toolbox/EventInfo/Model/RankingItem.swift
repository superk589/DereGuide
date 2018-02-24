//
//  RankingItem.swift
//  DereGuide
//
//  Created by zzk on 24/02/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

struct RankingItem {
    
    init(score: UInt, rank: UInt) {
        self.score = score
        self.rank = rank
    }
    
    var score: UInt
    var rank: UInt
}
