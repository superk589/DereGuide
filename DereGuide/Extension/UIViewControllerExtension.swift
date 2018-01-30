//
//  UIViewControllerExtension.swift
//  DereGuide
//
//  Created by zzk on 30/01/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static var root: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
}
