//
//  CGSSNotificationCenter.swift
//  CGSSFoundation
//
//  Created by zzk on 16/7/10.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

open class CGSSNotificationCenter: NSObject {

    open static func post( _ name:String, object: AnyObject?) {
        let prefixedName = "CGSS_" + name
        NotificationCenter.default.post(name: Notification.Name(rawValue: prefixedName), object: object)
    }
    
    open static func add(_ observer: AnyObject, selector: Selector, name: String, object: AnyObject?) {
        let prefixedName = "CGSS_" + name
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: prefixedName), object: object)
    }
    open static func add(_ observer: AnyObject, selector: Selector, name:String, object:AnyObject?, queue: OperationQueue, using:@escaping (Notification)->Void) {
        let prefixedName = "CGSS_" + name
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: prefixedName), object: object, queue: queue, using: using)
    }
    open static func removeAll(_ observer:AnyObject) {
        NotificationCenter.default.removeObserver(observer)
    }
    
    open static func remove(_ observer:AnyObject, name: String, object: AnyObject?) {
        let prefixedName = "CGSS_" + name
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: prefixedName), object: object)
    }
}
