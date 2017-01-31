//
//  DateExtension.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/15.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

extension Date {
    func toString(format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone = TimeZone.tokyo) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
