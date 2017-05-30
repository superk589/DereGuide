//
//  BirthdayCenter.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/16.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import UserNotifications
import SDWebImage

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
    
    var nextBirthdayComponents: DateComponents {
//        var calendar = Calendar(identifier: .gregorian)
//        calendar.timeZone = UserDefaults.standard.birthdayTimeZone
//        
//        let now = Date()
//        var dateComponents = calendar.dateComponents([.year, .month, .day], from: now)
//        if (birthMonth, birthDay) < (dateComponents.month!, dateComponents.day!) {
//            dateComponents.year = dateComponents.year! + 1
//        }
//        dateComponents.month = birthMonth
//        dateComponents.day = birthDay
//
//        dateComponents.timeZone = UserDefaults.standard.birthdayTimeZone
//        return dateComponents

        let date = self.nextBirthday
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = TimeZone.current
        return gregorian.dateComponents([.year, .month, .day, .hour, .minute], from: date!)
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
                    
                    if #available(iOS 10.0, *) {
                        // 1. 创建通知内容
                        let content = UNMutableNotificationContent()
                        content.title = NSLocalizedString("偶像生日提醒", comment: "")
                        let body = NSLocalizedString("今天是%@的生日(%d月%d日)", comment: "生日通知正文")
                        content.body = String.init(format: body, char.name!, char.birthMonth!, char.birthDay!)
                        
                        // 2. 创建发送触发
                        let trigger = UNCalendarNotificationTrigger(dateMatching: char.nextBirthdayComponents, repeats: false)
                        
                        // 3. 发送请求标识符
                        let requestIdentifier = Config.bundlerId + ".\(char.name!)"
                        
                        
                        content.categoryIdentifier = NotificationHandler.UserNotificationCategoryType.birthday
                        
                        let relatedCards = CGSSDAO.shared.findCardsByCharId(char.charaId).sorted { $0.albumId > $1.albumId }
                        var userInfo: [String: Any] = ["charName": char.name!, "charaId": char.charaId!]
                        if let spriteImageRef = relatedCards.first?.spriteImageRef {
                            // 注意: userInfo 中只能存属性列表
                            userInfo["cardSpriteImageRef"] = spriteImageRef
                        }
                        content.userInfo = userInfo
                        
                        let url = URL.init(string: DataURL.Images + "/icon_char/\(char.charaId!).png")!
                
                        if let key = SDWebImageManager.shared().cacheKey(for: url) {
                            if let path = SDImageCache.shared().defaultCachePath(forKey: key) {
                                let imageURL = URL(fileURLWithPath: path)
                                // by adding into a notification, the attachment will be moved to a new location so you need to copy it first
                                let fileManager = FileManager.default
                                let newURL = URL(fileURLWithPath: Path.tmp + "/\(char.charaId!).png")
                                do {
                                    try fileManager.copyItem(at: imageURL, to: newURL)
                                } catch {
                                    print(error.localizedDescription)
                                }
                                if let attachment = try? UNNotificationAttachment(identifier: "imageAttachment", url: newURL, options: nil) {
                                    content.attachments = [attachment]
                                }
                            }
                        }

                        // 4. 创建一个发送请求
                        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
                        
                        // 将请求添加到发送中心
//                        print("notification scheduling: \(requestIdentifier)")
                        UNUserNotificationCenter.current().add(request) { error in
                            if error == nil {
                                print("notification scheduled: \(requestIdentifier)")
                            } else {
                                // if userinfo is not property list, this closure will not be executed, no errors here
                                print("notification falied in scheduling: \(requestIdentifier)")
                            }
                        }
                    } else {
                        // Fallback on earlier versions
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
        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            
        }
        if let notifications = UIApplication.shared.scheduledLocalNotifications {
            for notification in notifications {
                if notification.category == "Birthday" {
                    UIApplication.shared.cancelLocalNotification(notification)
                }
            }
        }
    }
}
