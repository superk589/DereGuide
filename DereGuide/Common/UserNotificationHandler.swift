//
//  UserNotificationHandler.swift
//  DereGuide
//
//  Created by zzk on 2017/5/24.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import UserNotifications

@available(iOS 10.0, *)
class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    static let `default` = NotificationHandler()
    
    private override init() {
        super.init()
        self.registerNotificationCategory()
    }
    
    struct UserNotificationCategoryType {
        static let birthday = "birthdayCategory"
    }
    
    struct BirthdayActionType {
        static let happy = "action.happyBirthday"
        static let cancel = "action.cancel"
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.badge, .alert])
        
        // 如果不想显示某个通知，可以直接用空 options 调用 completionHandler:
        // completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // let category = response.notification.request.content.categoryIdentifier
        let action = response.actionIdentifier
        if action == UNNotificationDismissActionIdentifier {
            // dismissed, do nothing
        } else if action == BirthdayActionType.happy || action == BirthdayActionType.cancel {
            handleBirthdayAction(response: response)
        } else if action == UNNotificationDefaultActionIdentifier {
            openSpecificPageBy(response: response)
        }
        completionHandler()
    }
    
    private func openSpecificPageBy(response: UNNotificationResponse) {
        let userInfo = response.notification.request.content.userInfo
        if let charaId = userInfo["charaId"] as? Int {
            if let char = CGSSDAO.shared.findCharById(charaId),
                let nvc = CGSSClient.shared.tabBarController?.selectedViewController as? UINavigationController {
                let vc = CharDetailViewController()
                vc.char = char
                vc.hidesBottomBarWhenPushed = true
                nvc.pushViewController(vc, animated: false)
                nvc.navigationBar.setNeedsLayout()
            }
        }
    }
    
    private func handleBirthdayAction(response: UNNotificationResponse) {        
        let actionType = response.actionIdentifier
        if actionType == BirthdayActionType.happy {
            let charName = response.notification.request.content.userInfo["charName"]! as! String
            let reply = NSLocalizedString("%@收到了你的祝福", comment: "")
            let message = String.init(format: reply, charName)
            
            openSpecificPageBy(response: response)
            // 延时2秒, 同时进行会导致无法弹出角色详情页面
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                UIAlertController.showConfirmAlertFromTopViewController(message: message)
            })
            
        } else if actionType == BirthdayActionType.cancel {
            // do nothing
        }
    }
    
    private func registerNotificationCategory() {
        let birthdayCategory: UNNotificationCategory = {
            // 1
//            let inputAction = UNTextInputNotificationAction(
//                identifier: "action.input",
//                title: "Input",
//                options: [.foreground],
//                textInputButtonTitle: "Send",
//                textInputPlaceholder: "What do you want to say...")
            
            // 2
            let happyBirthdayAction = UNNotificationAction(
                identifier: BirthdayActionType.happy,
                title: NSLocalizedString("生日快乐!!", comment: ""),
                options: [.foreground])
            
            let cancelAction = UNNotificationAction(
                identifier: BirthdayActionType.cancel,
                title: NSLocalizedString("取消", comment: ""),
                options: [.destructive])
            
            // 3
            return UNNotificationCategory(identifier: UserNotificationCategoryType.birthday, actions: [happyBirthdayAction, cancelAction], intentIdentifiers: [], options: [.customDismissAction])
        }()
        
        UNUserNotificationCenter.current().setNotificationCategories([birthdayCategory])
    }
    
}
