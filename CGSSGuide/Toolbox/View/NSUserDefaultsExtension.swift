//
//  NSUserDefaultsExtension.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/16.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

extension NSUserDefaults {
    
    var birthdayTimeZone: NSTimeZone {
        let timeZoneString = self.valueForKey("BirthdayTimeZone") as? String ?? "Asia/Tokyo"
        switch timeZoneString {
        case "System":
            return NSTimeZone.systemTimeZone()
        default:
            return NSTimeZone.init(name: timeZoneString)!
        }
        
    }
    
    var shouldPostBirthdayNotice: Bool {
        return NSUserDefaults.standardUserDefaults().valueForKey("BirthdayNotice") as? Bool ?? false
    }
    var shouldCacheFullImage: Bool {
        return NSUserDefaults.standardUserDefaults().valueForKey("FullImageCache") as? Bool ?? true
    }
}
