//
//  LFSamplePoint.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct LFSamplePoint<T> {
    var probability: Double {
        didSet {
            assert(probability <= 1 || probability >= 0)
        }
    }
    var value: T
}
