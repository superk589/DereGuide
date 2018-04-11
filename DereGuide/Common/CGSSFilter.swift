//
//  CGSSFilter.swift
//  DereGuide
//
//  Created by zzk on 2017/1/14.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

protocol CGSSFilter {

    var searchText: String { set get }
    
    func toDictionary() -> NSDictionary
    
    func save(to path: String)
    
    init?(fromFile path: String)

}
