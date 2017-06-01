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
    
    func executeDocumentReset(reset: ((Int)->Void)) {
        let documentVersion = Bundle.main.infoDictionary?["Document Version"] as? Int ?? 1
        let lastVersion = UserDefaults.standard.value(forKey: "LastDocumentVersion") as? Int ?? 0
        if documentVersion > lastVersion {
            reset(lastVersion)
        }
        defer {
            UserDefaults.standard.set(documentVersion, forKey: "LastDocumentVersion")
        }
    }
    
    var hasRated: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "hasRated")
        }
        get {
            return UserDefaults.standard.value(forKey: "hasRated") as? Bool ?? false
        }
    }
    
    var allowOverloadSkillsTriggerLifeCondition: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "allowOverloadSkillsTriggerLifeCondition")
        }
        get {
            return UserDefaults.standard.bool(forKey: "allowOverloadSkillsTriggerLifeCondition")
        }
    }
    
    var roomUpValue: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "roomUpValue")
        }
        get {
            return UserDefaults.standard.object(forKey: "roomUpValue") as? Int ?? 10
        }
    }
    
    var greatPercent: Double {
        set {
            UserDefaults.standard.set(newValue, forKey: "greatPercent")
        }
        get {
            return UserDefaults.standard.double(forKey: "greatPercent")
        }
    }
    
    var simulationTimes: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "simulationTimes")
        }
        get {
            return UserDefaults.standard.object(forKey: "simulationTimes") as? Int ?? 10000
        }
    }
}
