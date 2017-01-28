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
    
    var shouldShowAd: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "shouldShowAd")
        }
        get {
            return UserDefaults.standard.value(forKey: "shouldShowAd") as? Bool ?? true
        }
    }
    
    func executeDocumentReset(reset:(()->Void)) {
        defer {
            UserDefaults.standard.set(documentVersion, forKey: "LastDocumentVersion")
        }
        let documentVersion = Bundle.main.infoDictionary?["Document Version"] as? Int ?? 1
        let lastVersion = UserDefaults.standard.value(forKey: "LastDocumentVersion") as? Int ?? 0
        if documentVersion > lastVersion {
            reset()
        }
    }
}
