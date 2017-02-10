//
//  StringExtension.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/14.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

extension String {
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone = TimeZone.tokyo) -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        let newDate = dateFormatter.date(from: self) ?? Date()
        return newDate
    }
    
    
    /// 获取匹配的字符串
    ///
    /// - Parameters:
    ///   - pattern: regular pattern
    ///   - index: index = 0 no capture, index = 1 the first capture, ...
    /// - Returns: matched strings
    func match(pattern: String, index: Int = 0) -> [String] {
        let regex = try? NSRegularExpression.init(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let res = regex!.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count))
        var arr = [String]()
        for checkingRes in res {
            arr.append((self as NSString).substring(with: checkingRes.rangeAt(index)))
        }
        return arr
    }
}
