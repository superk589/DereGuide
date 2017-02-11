//
//  CGSSNotificationCenter.swift
//  CGSSFoundation
//
//  Created by zzk on 16/7/10.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

open class CGSSNotificationCenter: NSObject {

    static let updateEnd = Notification.Name.init("CGSS_UPDATE_END")
    static let gameResoureceProcessedEnd = Notification.Name.init("CGSS_PROCESS_END")
    static let saveEnd = Notification.Name.init("CGSS_SAVE_END")
    
    open static func post( _ name: Notification.Name, object: Any?) {
        NotificationCenter.default.post(name: name, object: object)
    }
    
    open static func post(name: Notification.Name, object: Any?, userInfo: [AnyHashable: Any]?) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
    
    open static func add(_ observer: Any, selector: Selector, name: Notification.Name, object: Any?) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }
    open static func add(_ observer: Any, selector: Selector, name: Notification.Name, object:Any?, queue: OperationQueue, using:@escaping (Notification)->Void) {
        NotificationCenter.default.addObserver(forName: name, object: object, queue: queue, using: using)
    }
    open static func removeAll(_ observer:Any) {
        NotificationCenter.default.removeObserver(observer)
    }
    
    open static func remove(_ observer:Any, name: Notification.Name, object: Any?) {
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
    }
}
