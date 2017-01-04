//
//  UIFontExtenstion.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/4.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

extension UIFont {
    static func medium(size:CGFloat) -> UIFont! {
        return UIFont.init(name: "PingFangSC-Medium", size: size)
    }
    static func light(size:CGFloat) -> UIFont! {
        return UIFont.init(name: "PingFangSC-Light", size: size)
    }
    static func regular(size:CGFloat) -> UIFont! {
        return UIFont.init(name: "PingFangSC-Regular", size: size)
    }
}
