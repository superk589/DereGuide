//
//  NSUserDefaultsExtension.swift
//  DereGuide
//
//  Created by zzk on 16/8/16.
//  Copyright © 2016 zzk. All rights reserved.
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
    
    func executeDocumentReset(reset: ((Int) -> Void)) {
        let documentVersion = Bundle.main.infoDictionary?["Document version"] as? Int ?? 1
        
        defer {
            UserDefaults.standard.set(documentVersion, forKey: "LastDocumentVersion")
        }
        
        // if user is the first time launching this app, the LastDocumentVersion is nil, then do nothing
        guard let lastVersion = UserDefaults.standard.value(forKey: "LastDocumentVersion") as? Int else {
            return
        }
        if documentVersion > lastVersion {
            reset(lastVersion)
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
    
    var firstTimeUsingUnitEditingPage: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "firstTimeUsingUnitEditingPage")
        }
        get {
            return UserDefaults.standard.value(forKey: "firstTimeUsingUnitEditingPage") as? Bool ?? true
        }
    }
    
    var firstTimeComposingMyProfile: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "firstTimeComposingMyProfile")
        }
        get {
            return UserDefaults.standard.value(forKey: "firstTimeComposingMyProfile") as? Bool ?? true
        }
    }
    
    var firstTimeComposingDMMyProfile: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "firstTimeComposingDMMyProfile")
        }
        get {
            return UserDefaults.standard.value(forKey: "firstTimeComposingDMMyProfile") as? Bool ?? true
        }
    }
    
    var firstTimeShowLiveView: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "firstTimeShowLiveView")
        }
        get {
            return UserDefaults.standard.value(forKey: "firstTimeShowLiveView") as? Bool ?? true
        }
    }
    
    var shouldHideDifficultyText: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "shouldHideDifficultyText")
        }
        get {
            return UserDefaults.standard.value(forKey: "shouldHideDifficultyText") as? Bool ?? false
        }
    }
    
}
