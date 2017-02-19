//
//  CGSSGlobal.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ReachabilitySwift


struct Config {
    static let iAPRemoveADProductId: Set<String> = ["cgssguide_remove_ad_small", "cgssguide_remove_ad_medium"]
}

struct Screen {
    // 当前屏幕的宽度和高度常量
    public static let width = UIScreen.main.bounds.width
    public static let height = UIScreen.main.bounds.height
    // 当前屏幕1坐标的像素点数量
    public static let scale = UIScreen.main.scale
}

struct Font {
    static let title: UIFont! = UIFont.systemFont(ofSize: 16)
    static let content: UIFont! = UIFont.systemFont(ofSize: 14)
    static func number(of size: CGFloat) -> UIFont! {
        return UIFont.init(name: "menlo", size: size)
    }
    static func courier(of size: CGFloat) -> UIFont! {
        return UIFont.init(name: "Courier New", size: size)
    }
}

struct Color {
    // 常用颜色
    public static let vocal = UIColor.init(red: 1.0 * 236 / 255, green: 1.0 * 87 / 255, blue: 1.0 * 105 / 255, alpha: 1)
    public static let dance = UIColor.init(red: 1.0 * 89 / 255, green: 1.0 * 187 / 255, blue: 1.0 * 219 / 255, alpha: 1)
    public static let visual = UIColor.init(red: 1.0 * 254 / 255, green: 1.0 * 154 / 255, blue: 1.0 * 66 / 255, alpha: 1)
    public static let life = UIColor.init(red: 1.0 * 75 / 255, green: 1.0 * 202 / 255, blue: 1.0 * 137 / 255, alpha: 1)
    
    public static let debut = UIColor.init(red: 1.0 * 138 / 255, green: 1.0 * 206 / 255, blue: 1.0 * 233 / 255, alpha: 1)
    public static let regular = UIColor.init(red: 1.0 * 253 / 255, green: 1.0 * 164 / 255, blue: 1.0 * 40 / 255, alpha: 1)
    public static let pro = UIColor.init(red: 1.0 * 254 / 255, green: 1.0 * 183 / 255, blue: 1.0 * 194 / 255, alpha: 1)
    public static let master = UIColor.init(red: 1.0 * 147 / 255, green: 1.0 * 236 / 255, blue: 1.0 * 148 / 255, alpha: 1)
    public static let masterPlus = UIColor.init(red: 1.0 * 255 / 255, green: 1.0 * 253 / 255, blue: 1.0 * 114 / 255, alpha: 1)
    
    public static let cute = UIColor.init(red: 1.0 * 248 / 255, green: 1.0 * 24 / 255, blue: 1.0 * 117 / 255, alpha: 1)
    public static let cool = UIColor.init(red: 1.0 * 42 / 255, green: 1.0 * 113 / 255, blue: 1.0 * 247 / 255, alpha: 1)
    public static let passion = UIColor.init(red: 1.0 * 250 / 255, green: 1.0 * 168 / 255, blue: 1.0 * 57 / 255, alpha: 1)
    
    public static let parade = UIColor.init(red: 1.0 * 22 / 255, green: 1.0 * 87 / 255, blue: 1.0 * 250 / 255, alpha: 1)
    public static let kyalapon = UIColor.init(red: 1.0 * 252 / 255, green: 1.0 * 60 / 255, blue: 1.0 * 169 / 255, alpha: 1)
    public static let groove = UIColor.init(red: 1.0 * 238 / 255, green: 1.0 * 175 / 255, blue: 1.0 * 50 / 255, alpha: 1)

    public static let party = UIColor.init(red: 1.0 * 89 / 255, green: 1.0 * 192 / 255, blue: 1.0 * 50 / 255, alpha: 1)
    public static let tradition = UIColor.init(red: 1.0 * 113 / 255, green: 1.0 * 80 / 255, blue: 1.0 * 69 / 255, alpha: 1)
    
    public static let normalGacha = UIColor.init(red: 1.0 * 253 / 255, green: 1.0 * 186 / 255, blue: 1.0 * 80 / 255, alpha: 1)
    public static let limitedGacha = UIColor.init(red: 1.0 * 236 / 255, green: 1.0 * 103 / 255, blue: 1.0 * 105 / 255, alpha: 1)
    public static let cinFesGacha = UIColor.init(red: 1.0 * 25 / 255, green: 1.0 * 154 / 255, blue: 1.0 * 218 / 255, alpha: 1)
    
    public static let allType = UIColor.darkGray

    static let separator = UIColor.init(red: 0.25, green: 0.25, blue: 0.25, alpha: 1)
}



public class CGSSGlobal: NSObject {
    
    // 当前屏幕的宽度和高度常量
    public static let width = UIScreen.main.bounds.width
    public static let height = UIScreen.main.bounds.height
    // 当前屏幕1坐标的像素点数量
    public static let scale = UIScreen.main.scale

    // 用于GridView的字体
    public static let numberFont = UIFont.init(name: "menlo", size: 14)
    public static let alphabetFont = UIFont.systemFont(ofSize: 14)
    
    public static let fullImageWidth: CGFloat = 1280
    public static let fullImageHeight: CGFloat = 824
    
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
    
    static var languageType: LanguageType {
        return LanguageType.init(identifier: Locale.current.identifier)
    }
    
    // max = 15921 + 500 + 500 + 220 
    // ceil(0.5 × max × 1.3) * 10
    static let defaultSupportAppeal = 111420
    
}

enum LanguageType {
    case en
    case zh
    case ja
    case other
    init(identifier:String) {
        switch identifier {
        case let x where x.hasPrefix("en"):
            self = .en
        case let x where x.hasPrefix("zh"):
            self = .zh
        case let x where x.hasPrefix("ja"):
            self = .ja
        default:
            self = .other
        }
    }
}

