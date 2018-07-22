//
//  CGSSGlobal.swift
//  DereGuide
//
//  Created by zzk on 16/6/28.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit
import Reachability

struct Config {
    static let iAPRemoveADProductIDs: Set<String> = ["dereguide_small_tips", "dereguide_medium_tips"]
    static let bundleID = "com.zzk.cgssguide"
    static let unityVersion = "5.4.5p1"
    
    static let cloudKitDebug = true
    static let maxNumberOfStoredUnits = 100
    static let maxCharactersOfMessage = 200
    
    #if DEBUG
    static let cloudKitFetchLimits = 5
    #else
    static let cloudKitFetchLimits = 20
    #endif
    
    static let appName = NSLocalizedString("DereGuide", comment: "")
    
    static let maximumSinglePotential = 10
    static let maximumTotalPotential = 35
    
    // max = 15928 + 500 + 500 + 500
    // ceil(0.5 × max × 1.3) * 10
    static let maximumSupportAppeal = 113290
}

struct NotificationCategory {
    static let birthday = "Birthday"
}

struct Path {
    static let cache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    static let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    static let library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
    static let home = NSHomeDirectory()
    
    // include the last "/"
    static let temporary = NSTemporaryDirectory()
}

struct Screen {
    
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    // 当前屏幕1坐标的像素点数量
    static var scale: CGFloat {
        return UIScreen.main.scale
    }
    
    // FIXME: do not use these two, because in multi-task mode shortSide or longSide does not make sense.
    static let shortSide = min(width, height)
    static let longSide = max(width, height)
}

public class CGSSGlobal {
    
    // 当前屏幕的宽度和高度常量
    public static let width = UIScreen.main.bounds.width
    public static let height = UIScreen.main.bounds.height
    // 当前屏幕1坐标的像素点数量
    public static let scale = UIScreen.main.scale

    // 用于GridView的字体
    public static let numberFont = UIFont.init(name: "menlo", size: 14)
    public static let alphabetFont = UIFont.systemFont(ofSize: 14)
    
    public static let spreadImageWidth: CGFloat = 1280
    public static let spreadImageHeight: CGFloat = 824
    
    static let rarityToStirng: [String] = ["", "N", "N+", "R", "R+", "SR", "SR+", "SSR", "SSR+"]
    
    static let appid = "1131934691"
    
    // 时区转换
    static func getDateFrom(oldDate: NSDate, timeZone: NSTimeZone) -> NSDate {
        let inv = timeZone.secondsFromGMT(for: oldDate as Date)
        let timeInv = TimeInterval(inv)
        let newDate = oldDate.addingTimeInterval(timeInv)
        return newDate
        
    }
    
    static func isWifi() -> Bool {
        if let reachability = Reachability() {
            if reachability.connection == .wifi {
                return true
            }
        }
        return false
    }
    
    static func isMobileNet() -> Bool {
        if let reachability = Reachability() {
            if reachability.connection == .cellular {
                return true
            }
        }
        return false
    }
    
    static var languageType: LanguageType {
        if let code = Locale.preferredLanguages.first {
            return LanguageType(identifier: code)
        } else {
            return .en
        }
    }
    
}

enum LanguageType {
    case en
    case cn
    case tw
    case ja
    case other
    init(identifier: String) {
        switch identifier {
        case let x where x.hasPrefix("en"):
            self = .en
        case let x where x.hasPrefix("zh-Hans"):
            self = .cn
        case let x where x.hasPrefix("zh-Hant"):
            self = .tw
        case let x where x.hasPrefix("ja"):
            self = .ja
        default:
            self = .other
        }
    }
}
