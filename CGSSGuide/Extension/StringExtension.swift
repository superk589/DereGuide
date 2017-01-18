//
//  StringExtension.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/14.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

extension String {
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone = CGSSGlobal.timeZoneOfTyoko) -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        let newDate = dateFormatter.date(from: self) ?? Date()
        return newDate
    }
}
