//
//  NSUserDefaultsExtension.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/16.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    var birthdayTimeZone: TimeZone {
        let timeZoneString = self.value(forKey: "BirthdayTimeZone") as? String ?? "Asia/Tokyo"
        switch timeZoneString {
        case "System":
            return TimeZone.current
        default:
            return TimeZone.init(identifier: timeZoneString)!
        }
        
    }
    
    var shouldPostBirthdayNotice: Bool {
        return UserDefaults.standard.value(forKey: "BirthdayNotice") as? Bool ?? false
    }
    var shouldCacheFullImage: Bool {
        return UserDefaults.standard.value(forKey: "FullImageCache") as? Bool ?? true
    }
}
