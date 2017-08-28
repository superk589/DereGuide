//
//  NSAtributedStringExtension.swift
//  DereGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let resultString = NSMutableAttributedString.init(attributedString: lhs)
        resultString.append(rhs)
        return resultString
    }
    
}
