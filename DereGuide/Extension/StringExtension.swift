//
//  StringExtension.swift
//  DereGuide
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
        
        // If not set this, and in your phone settings select a region that defaults to a 24-hour time, for example "United Kingdom" or "France". Then, disable the "24 hour time" from the settings. Now if you create an NSDateFormatter without setting its locale, "HH" will not work.
        // Reference from https://stackoverflow.com/questions/29374181/nsdateformatter-hh-returning-am-pm-on-ios-8-device
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
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
        let res = regex!.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, count))
        var arr = [String]()
        for checkingRes in res {
            arr.append((self as NSString).substring(with: checkingRes.range(at: index)))
        }
        return arr
    }
    
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate(capacity: digestLen)
        
        return String(format: hash as String)
    }
    
}
