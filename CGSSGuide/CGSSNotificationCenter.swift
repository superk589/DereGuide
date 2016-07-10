//
//  CGSSNotificationCenter.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/10.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSNotificationCenter: NSObject {

    static func post( name:String, object: AnyObject?) {
        let prefixdedName = "CGSS_" + name
        NSNotificationCenter.defaultCenter().postNotificationName(prefixdedName, object: object)
    }
    static func add(observer: AnyObject, selector: Selector, name: String, object: AnyObject?) {
        let prefixdedName = "CGSS_" + name
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: prefixdedName, object: object)
    }
    static func removeAll(observer:AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
    
    static func remove(observer:AnyObject, name: String, object: AnyObject?) {
        let prefixdedName = "CGSS_" + name
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: prefixdedName, object: object)
    }
}
