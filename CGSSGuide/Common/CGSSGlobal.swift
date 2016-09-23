//
//  CGSSGlobal.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ReachabilitySwift

public class CGSSGlobal: NSObject {
    
    // 当前屏幕的宽度和高度常量
    public static let width = UIScreen.main.bounds.width
    public static let height = UIScreen.main.bounds.height
    // 当前屏幕1坐标的像素点数量
    public static let scale = UIScreen.main.scale
    // 常用颜色
    public static let vocalColor = UIColor.init(red: 1.0 * 236 / 255, green: 1.0 * 87 / 255, blue: 1.0 * 105 / 255, alpha: 1)
    public static let danceColor = UIColor.init(red: 1.0 * 89 / 255, green: 1.0 * 187 / 255, blue: 1.0 * 219 / 255, alpha: 1)
    public static let visualColor = UIColor.init(red: 1.0 * 254 / 255, green: 1.0 * 154 / 255, blue: 1.0 * 66 / 255, alpha: 1)
    public static let lifeColor = UIColor.init(red: 1.0 * 75 / 255, green: 1.0 * 202 / 255, blue: 1.0 * 137 / 255, alpha: 1)
    
    public static let debutColor = UIColor.init(red: 1.0 * 138 / 255, green: 1.0 * 206 / 255, blue: 1.0 * 233 / 255, alpha: 1)
    public static let regularColor = UIColor.init(red: 1.0 * 253 / 255, green: 1.0 * 164 / 255, blue: 1.0 * 40 / 255, alpha: 1)
    public static let proColor = UIColor.init(red: 1.0 * 254 / 255, green: 1.0 * 183 / 255, blue: 1.0 * 194 / 255, alpha: 1)
    public static let masterColor = UIColor.init(red: 1.0 * 147 / 255, green: 1.0 * 236 / 255, blue: 1.0 * 148 / 255, alpha: 1)
    public static let masterPlusColor = UIColor.init(red: 1.0 * 255 / 255, green: 1.0 * 253 / 255, blue: 1.0 * 114 / 255, alpha: 1)
    
    public static let cuteColor = UIColor.init(red: 1.0 * 248 / 255, green: 1.0 * 24 / 255, blue: 1.0 * 117 / 255, alpha: 1)
    public static let coolColor = UIColor.init(red: 1.0 * 42 / 255, green: 1.0 * 113 / 255, blue: 1.0 * 247 / 255, alpha: 1)
    public static let passionColor = UIColor.init(red: 1.0 * 250 / 255, green: 1.0 * 168 / 255, blue: 1.0 * 57 / 255, alpha: 1)
    // public static let allTypeColor = UIColor.init(red: 1.0*255/255, green: 1.0*253/255, blue: 1.0*114/255, alpha: 1)
    public static let allTypeColor = UIColor.darkGray
    
    // 用于GridView的字体
    public static let numberFont = UIFont.init(name: "menlo", size: 14)
    public static let alphabetFont = UIFont.systemFont(ofSize: 14)
    
    public static let fullImageWidth: CGFloat = 1280
    public static let fullImageHeight: CGFloat = 824
    
    public static let timeZoneOfTyoko = TimeZone.init(identifier: "Asia/Tokyo")!
    
    public static func getStringByPattern(str: String, pattern: String) -> [NSString] {
        let regex = try? NSRegularExpression.init(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let res = regex!.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
        var arr = Array<NSString>()
        for checkingRes in res {
            arr.append((str as NSString).substring(with: checkingRes.range) as NSString)
        }
        return arr
    }
    
    public static func diffStringFromInt(i: Int) -> String {
        switch i {
        case 1:
            return "DEBUT"
        case 2:
            return "REGULAR"
        case 3:
            return "PRO"
        case 4:
            return "MASTER"
        case 5:
            return "MASTER+"
        default:
            return "UNKNOWN"
        }
    }
    
    static let diffFactor: [Int: Float] = [
        5: 1.0,
        6: 1.025,
        7: 1.05,
        8: 1.075,
        9: 1.1,
        10: 1.2,
        11: 1.225,
        12: 1.25,
        13: 1.275,
        14: 1.3,
        15: 1.4,
        16: 1.425,
        17: 1.45,
        18: 1.475,
        19: 1.5,
        20: 1.6,
        21: 1.65,
        22: 1.7,
        23: 1.75,
        24: 1.8,
        25: 1.85,
        26: 1.9,
        27: 1.95,
        28: 2,
        29: 2.1,
        30: 2.2,
    ]
    
    static let comboFactor: [Float] = [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.7, 2.0]
    
    static let criticalPercent: [Int] = [0, 5, 10, 25, 50, 70, 80, 90]
    
    static let rarityToStirng: [String] = ["", "N", "N+", "R", "R+", "SR", "SR+", "SSR", "SSR+"]
    
    static let potentialOfLevel: [CGSSRarityTypes:[Int]] = [
        .n : [0, 80, 160, 250, 340, 440, 540, 650, 760, 880, 1000],
        .r : [0, 60, 120, 180, 255, 330, 405, 480, 570, 660, 750],
        .sr : [0, 60, 120, 180, 250, 320, 390, 460, 540, 620, 700],
        .ssr : [0, 40, 80, 120, 170, 220, 270, 320, 380, 440, 500]
    ]
    
    static let maxPotentialTotal = 25
    static let maxPotentialSingle = 10
    
    // 传入0-99999的rate 判断是否触发
    static func isProc(rate: Int) -> Bool {
        let ran = arc4random_uniform(100000)
        if rate > Int(ran) {
            return true
        } else {
            return false
        }
    }
    
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
            if reachability.isReachableViaWiFi{
                return true
            }
        }
        return false
    }
    
    static func isMobileNet() -> Bool {
        if let reachability = Reachability() {
            if reachability.isReachableViaWWAN {
                return true
            }
        }
        return false
    }
    
    static let presetBackValue = 103463
    
}

