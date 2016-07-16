//
//  CGSSNotificationCenter.swift
//  CGSSFoundation
//
//  Created by zzk on 16/7/10.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

public class CGSSNotificationCenter: NSObject {

    public static func post( name:String, object: AnyObject?) {
        let prefixdedName = "CGSS_" + name
        NSNotificationCenter.defaultCenter().postNotificationName(prefixdedName, object: object)
    }
    
    public static func add(observer: AnyObject, selector: Selector, name: String, object: AnyObject?) {
        let prefixdedName = "CGSS_" + name
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: prefixdedName, object: object)
    }
    public static func removeAll(observer:AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
    
    public static func remove(observer:AnyObject, name: String, object: AnyObject?) {
        let prefixdedName = "CGSS_" + name
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: prefixdedName, object: object)
    }
}
