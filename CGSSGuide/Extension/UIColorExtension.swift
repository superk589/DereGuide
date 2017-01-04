//
//  UIColorExtension.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/4.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

extension UIColor {
    static func colorFrom(hexString: String) -> UIColor {
        var hexInt: UInt32 = 0
        let scanner = Scanner(string: hexString)
        scanner.scanHexInt32(&hexInt)
        let color = UIColor(
            red: CGFloat((hexInt & 0xFF0000) >> 16)/255,
            green: CGFloat((hexInt & 0xFF00) >> 8)/255,
            blue: CGFloat((hexInt & 0xFF))/255,
            alpha: 1)
        
        return color
    }
}


extension UIColor {
    static let lightSeparator: UIColor = UIColor.lightGray
}
