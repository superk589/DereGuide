//
//  LSRange.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct LSRange {
    var begin: Float
    var length: Float
    var end: Float {
        return begin + length
    }
}
