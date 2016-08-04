//
//  CGSSTool.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

public class CGSSTool: NSObject {

    //当前屏幕的宽度和高度常量
    public static let width = UIScreen.mainScreen().bounds.width
    public static let height = UIScreen.mainScreen().bounds.height
    
    public static let vocalColor = UIColor.init(red: 1.0*236/255, green: 1.0*87/255, blue: 1.0*105/255, alpha: 1)
    public static let danceColor = UIColor.init(red: 1.0*89/255, green: 1.0*187/255, blue: 1.0*219/255, alpha: 1)
    public static let visualColor = UIColor.init(red: 1.0*254/255, green: 1.0*154/255, blue: 1.0*66/255, alpha: 1)
    public static let lifeColor = UIColor.init(red: 1.0*75/255, green: 1.0*202/255, blue: 1.0*137/255, alpha: 1)
    
    public static let debutColor = UIColor.init(red: 1.0*138/255, green: 1.0*206/255, blue: 1.0*233/255, alpha: 1)
    public static let regularColor = UIColor.init(red: 1.0*253/255, green: 1.0*164/255, blue: 1.0*40/255, alpha: 1)
    public static let proColor = UIColor.init(red: 1.0*254/255, green: 1.0*183/255, blue: 1.0*194/255, alpha: 1)
    public static let masterColor = UIColor.init(red: 1.0*147/255, green: 1.0*236/255, blue: 1.0*148/255, alpha: 1)
    public static let masterPlusColor = UIColor.init(red: 1.0*255/255, green: 1.0*253/255, blue: 1.0*114/255, alpha: 1)
    
    public static let cuteColor = UIColor.init(red: 1.0*248/255, green: 1.0*24/255, blue: 1.0*117/255, alpha: 1)
    public static let coolColor = UIColor.init(red: 1.0*42/255, green: 1.0*113/255, blue: 1.0*247/255, alpha: 1)
    public static let passionColor = UIColor.init(red: 1.0*250/255, green: 1.0*168/255, blue: 1.0*57/255, alpha: 1)
    //public static let allTypeColor = UIColor.init(red: 1.0*255/255, green: 1.0*253/255, blue: 1.0*114/255, alpha: 1)
    
    public static let fullImageWidth:CGFloat = 1280
    public static let fullImageHeight:CGFloat = 824
    
    public static func getStringByPattern(str:String, pattern:String) -> [NSString] {
        let regex = try? NSRegularExpression.init(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive )
        let res = regex!.matchesInString(str, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
        var arr = Array<NSString>()
        for checkingRes in res {
            arr.append((str as NSString).substringWithRange(checkingRes.range))
        }
        return arr
    }
    
    
}