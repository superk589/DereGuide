//
//  BirthdayCenter.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/16.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

extension CGSSChar {
    var nextBirthday: Date! {
        let timeZone = UserDefaults.standard.birthdayTimeZone
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = timeZone
        
        let now = Date()
        var dateComp = gregorian.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: now)
        if (birthMonth, birthDay) < (dateComp.month!, dateComp.day!) {
            dateComp.year = dateComp.year! + 1
        }
        dateComp.month = birthMonth
        dateComp.day = birthDay
        return gregorian.date(from: dateComp)
    }
}

class BirthdayCenter {
    static let `default` = BirthdayCenter()
    var chars: [CGSSChar]!
    var lastSortDate: Date!
    
    private init() {
        prepare()
        NotificationCenter.default.addObserver(self, selector: #selector(prepare), name: .updateEnd, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func prepare() {
        let dao = CGSSDAO.shared
        chars = dao.charDict.allValues as! [CGSSChar]
        chars.sort { (char1, char2) -> Bool in
            char1.nextBirthday < char2.nextBirthday
        }
        lastSortDate = Date()
    }
    
    @objc func scheduleNotifications() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let strongSelf = self {
                strongSelf.removeNotifications()
                for char in strongSelf.getRecent(1, endDays: 30) {
                    let localNotification = UILocalNotification()
                    localNotification.fireDate = char.nextBirthday
                    let body = NSLocalizedString("今天是%@的生日(%d月%d日)", comment: "生日通知正文")
                    localNotification.alertBody = String.init(format: body, char.name!, char.birthMonth!, char.birthDay!)
                    localNotification.category = NotificationCategory.birthday
                    localNotification.userInfo = ["chara_id": char.charaId]
                    UIApplication.shared.scheduleLocalNotification(localNotification)
                }
            }
        }
    }
    
    func getRecent(_ startDays: Int, endDays: Int) -> [CGSSChar] {
        let timeZone = UserDefaults.standard.birthdayTimeZone
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = timeZone
        
        let now = Date()
        
        // 因为用户修改日期或自然时间变动时 重新排序
        if lastSortDate.truncateHours(timeZone: timeZone) != now.truncateHours(timeZone: timeZone) {
            prepare()
        }

        let start = now.addingTimeInterval(TimeInterval(startDays) * 3600 * 24).truncateHours(timeZone: timeZone)
        let end = now.addingTimeInterval(TimeInterval(endDays) * 3600 * 24).truncateHours(timeZone: timeZone)
        
        var arr = [CGSSChar]()
        for char in chars {
            if char.nextBirthday < start {
                continue
            }
            if char.nextBirthday > end {
                break
            }
            arr.append(char)
        }
        return arr
    }
    
    func removeNotifications() {
        if let notifications = UIApplication.shared.scheduledLocalNotifications {
            for notification in notifications {
                if notification.category == "Birthday" {
                    UIApplication.shared.cancelLocalNotification(notification)
                }
            }
        }
    }
}
