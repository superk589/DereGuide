//
//  DateExtension.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/15.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

extension Date {
    func toString(format: String) -> String {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = format
        return dateFormmater.string(from: self)
    }
}
