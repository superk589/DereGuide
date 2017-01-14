//
//  CGSSFilter.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/14.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol CGSSFilter {

    func toDictionary() -> NSDictionary
    
    func save(to path: String)
    
    init?(fromFile path: String)
    
}
