//
//  Array+SafeIndex.swift
//  DereGuide
//
//  Created by zzk on 25/10/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

extension Array {
    
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
    
}
