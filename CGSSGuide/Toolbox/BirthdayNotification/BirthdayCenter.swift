//
//  BirthdayCenter.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/16.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class BirthdayCenter: NSObject {
    static let defaultCenter = BirthdayCenter()
    var sortedChars: [CGSSChar]!
    fileprivate override init() {
        super.init()
        prepare()
        CGSSNotificationCenter.add(self, selector: #selector(prepare), name: CGSSNotificationCenter.updateEnd, object: nil)
    }
    
    var tempChar: CGSSChar!
    var indexOfTempChar: Int? {
        if tempChar == nil {
            return nil
        } else {
            return sortedChars.index(of: tempChar)
        }
    }
    func prepare() {
        let dao = CGSSDAO.sharedDAO
        sortedChars = dao.charDict.allValues as! [CGSSChar]
        sortInside()
    }
    
    func sortInside() {
        if let index = indexOfTempChar {
            sortedChars.remove(at: index)
        }
        tempChar = CGSSChar()
        let nowComp = getNowDateComponents()
        tempChar.birthDay = nowComp.day
        tempChar.birthMonth = nowComp.month
        sortedChars.append(tempChar)
        sortedChars.sort(by: { (char1, char2) -> Bool in
            if char1.birthMonth > char2.birthMonth {
                return false
            } else if char1.birthMonth == char2.birthMonth && char1.birthDay > char2.birthDay {
                return false
            } else if char1.birthMonth == char2.birthMonth && char1.birthDay == char2.birthDay && char2 == tempChar {
                return false
            } else {
                return true
            }
        })
    }
    
    func scheduleNotifications() {
        self.removeNotification()
        DispatchQueue.global(qos: .userInitiated).async {
            for char in self.getRecent(1, endDays: 30) {
                let localNotification = UILocalNotification()
                localNotification.fireDate = self.getNextBirthday(char)
                let body = NSLocalizedString("今天是%@的生日(%d月%d日)", comment: "生日通知正文")
                localNotification.alertBody = String.init(format: body, char.name!, char.birthMonth!, char.birthDay!)
                localNotification.category = "Birthday"
                UIApplication.shared.scheduleLocalNotification(localNotification)
            }
        }
    }
    
    func getRecent(_ startDays: Int, endDays: Int) -> [CGSSChar] {
        let timeZone = UserDefaults.standard.birthdayTimeZone
        var gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        gregorian.timeZone = timeZone
        var arr = [CGSSChar]()
        var index = indexOfTempChar!
        while true {
            index += 1
            if index >= sortedChars.count {
                index = 0
            }
            if sortedChars[index] == tempChar {
                break
            }
            let newdate = getNowDateTruncateHours()
            let date = getNextBirthday(sortedChars[index])
            let result = (gregorian as NSCalendar).components(NSCalendar.Unit.day, from: newdate!, to: date, options: NSCalendar.Options(rawValue: 0))
            if result.day! < startDays {
                continue
            } else if result.day! >= startDays && result.day! <= endDays {
                arr.append(sortedChars[index])
            } else {
                break
            }
        }
        return arr
    }
    
    func getNowDateComponents() -> DateComponents {
        let nowDate = Date()
        let timeZone = UserDefaults.standard.birthdayTimeZone
        var gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        gregorian.timeZone = timeZone
        let nowComp = (gregorian as NSCalendar).components(NSCalendar.Unit.init(rawValue: NSCalendar.Unit.year.rawValue | NSCalendar.Unit.month.rawValue | NSCalendar.Unit.day.rawValue), from: nowDate)
        return nowComp
    }
    
    func getNowDateTruncateHours() -> Date? {
        let nowComp = getNowDateComponents()
        var gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        gregorian.timeZone = UserDefaults.standard.birthdayTimeZone
        return gregorian.date(from: nowComp)
    }
    
    func getNextBirthday(_ char: CGSSChar) -> Date {
        
        let nowComp = getNowDateComponents()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        dateformatter.timeZone = UserDefaults.standard.birthdayTimeZone
        let dateString: String
        if nowComp.month! > char.birthMonth! || (nowComp.month! == char.birthMonth! && nowComp.day! > char.birthDay!) {
            dateString = String.init(format: "%04d%02d%02d", nowComp.year! + 1, char.birthMonth!, char.birthDay!)
        } else {
            dateString = String.init(format: "%04d%02d%02d", nowComp.year!, char.birthMonth!, char.birthDay!)
        }
        let date = dateformatter.date(from: dateString)
        return date!
    }
    
    func removeNotification() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let notifications = UIApplication.shared.scheduledLocalNotifications {
                for notification in notifications {
                    if notification.category == "Birthday" {
                        UIApplication.shared.cancelLocalNotification(notification)
                    }
                }
            }
        }
    }
}
