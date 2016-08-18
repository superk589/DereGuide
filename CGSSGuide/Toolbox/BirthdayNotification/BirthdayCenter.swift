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
    private override init() {
        super.init()
    }
    
    func scheduleNotifications() {
        self.removeNotification()
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            for char in self.getRecent(1, endDays: 30) {
                let localNotification = UILocalNotification()
                localNotification.fireDate = self.getNextBirthday(char)
                localNotification.alertBody = "今天是\(char.name!)的生日(\(char.birth_month!)月\(char.birth_day!)日)"
                localNotification.category = "Birthday"
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            }
        }
    }
    
    func getRecent(startDays: Int, endDays: Int) -> [CGSSChar] {
        let dao = CGSSDAO.sharedDAO
        let chars = dao.charDict.allValues as! [CGSSChar]
        let timeZone = NSUserDefaults.standardUserDefaults().birthdayTimeZone
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        gregorian?.timeZone = timeZone
        var arr = [CGSSChar]()
        for char in chars {
            let date = getNextBirthday(char)
            let dateformatter = NSDateFormatter()
            dateformatter.dateFormat = "yyyyMMdd"
            dateformatter.timeZone = NSUserDefaults.standardUserDefaults().birthdayTimeZone
            let newdate = getNowDateTruncateHours()
            let result = gregorian!.components(NSCalendarUnit.Day, fromDate: newdate!, toDate: date, options: NSCalendarOptions(rawValue: 0))
            if result.day >= startDays && result.day <= endDays {
                arr.append(char)
            }
        }
        return arr
    }
    
    func getNowDateComponents() -> NSDateComponents {
        let nowDate = NSDate()
        let timeZone = NSUserDefaults.standardUserDefaults().birthdayTimeZone
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        gregorian?.timeZone = timeZone
        let nowComp = gregorian!.components(NSCalendarUnit.init(rawValue: NSCalendarUnit.Year.rawValue | NSCalendarUnit.Month.rawValue | NSCalendarUnit.Day.rawValue), fromDate: nowDate)
        return nowComp
    }
    
    func getNowDateTruncateHours() -> NSDate? {
        let nowComp = getNowDateComponents()
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        gregorian?.timeZone = NSUserDefaults.standardUserDefaults().birthdayTimeZone
        return gregorian?.dateFromComponents(nowComp)
    }
    
    func getNextBirthday(char: CGSSChar) -> NSDate {
        
        let nowComp = getNowDateComponents()
        
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        dateformatter.timeZone = NSUserDefaults.standardUserDefaults().birthdayTimeZone
        let dateString: String
        if nowComp.month > char.birth_month! || (nowComp.month == char.birth_month! && nowComp.day > char.birth_day!) {
            dateString = String.init(format: "%04d%02d%02d", nowComp.year + 1, char.birth_month!, char.birth_day!)
        } else {
            dateString = String.init(format: "%04d%02d%02d", nowComp.year, char.birth_month!, char.birth_day!)
        }
        let date = dateformatter.dateFromString(dateString)
        return date!
    }
    
    func removeNotification() {
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications {
                for notification in notifications {
                    if notification.category == "Birthday" {
                        UIApplication.sharedApplication().cancelLocalNotification(notification)
                    }
                }
            }
        }
    }
}
