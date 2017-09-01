//
//  UITextFieldExtension.swift
//  DereGuide
//
//  Created by zzk on 01/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

extension UITextField {

    func check(pattern: String) -> Bool {
        if text?.match(pattern: pattern).count == 1 {
            return true
        } else {
            return false
        }
    }
    
}
