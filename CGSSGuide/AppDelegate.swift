//
//  AppDelegate.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/3.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SDWebImage
import ZKDrawerController
import UserNotifications
import CoreData

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 处理一系列启动任务
        
        // 设置通知代理
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = NotificationHandler.default
        } else {
            // Fallback on earlier versions
        }
        
        // 更新时清理过期的文档数据
        UserDefaults.standard.executeDocumentReset { (lastVersion) in
            if lastVersion < 2 {
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.FilterPath.live)
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.FilterPath.card)
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.SorterPath.card)
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.SorterPath.teamCard)
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.SorterPath.live)
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.SorterPath.char)
            }
            if lastVersion < 3 {
                CGSSCacheManager.shared.wipeLive()
            }
            if lastVersion < 5 {
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.FilterPath.card)
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.FilterPath.teamCard)
            }
            if lastVersion < 6 {
                let context = CoreDataStack.default.viewContext
                
                for team in CGSSTeamManager.default.teams {
                    let center = Member.insert(into: context, cardId: team.leader.id!, skillLevel: team.leader.skillLevel!, potential: team.leader.potential)
                    let guest = Member.insert(into: context, cardId: team.friendLeader.id!, skillLevel: team.friendLeader.skillLevel!, potential: team.friendLeader.potential)
                    var otherMembers = [Member]()
                    for sub in team.subs {
                        let member = Member.insert(into: context, cardId: sub.id!, skillLevel: sub.skillLevel!, potential: sub.potential)
                        otherMembers.append(member)
                    }
                    _ = Unit.insert(into: context, customAppeal: team.customAppeal, supportAppeal: team.supportAppeal, useCustomAppeal: team.usingCustomAppeal, center: center, guest: guest, otherMembers: otherMembers)
                }
                
                _ = context.saveOrRollback()
            }
        }
        
        // 规划近期偶像生日
        if UserDefaults.standard.shouldPostBirthdayNotice {
            BirthdayCenter.default.scheduleNotifications()
        }
        
        // 设置SDWebImage过期时间
        SDImageCache.shared().config.maxCacheAge = 60 * 60 * 24 * 365 * 10 // 10年缓存时间
        
        // 初始化DrawerController和TabBarController
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let rootTabBarController = sb.instantiateViewController(withIdentifier: "RootTabBarController") as! RootTabBarController
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let drawerController = ZKDrawerController.init(main: rootTabBarController)
        drawerController.drawerStyle = .cover
        drawerController.gestureRecognizerWidth = 120
        window?.rootViewController = drawerController
        window?.makeKeyAndVisible()
        CGSSClient.shared.drawerController = drawerController
        CGSSClient.shared.tabBarController = rootTabBarController
        
        // 判断是否通过本地消息进入, 如果是跳转到指定页面
        if let notification = launchOptions?[.localNotification] as? UILocalNotification {
            openSpecificPageWithLocalNotification(notification)
        }
        
        return true
    }
    
    enum ShortcutItemType: String {
        case card = "com.zzk.cgssguide.First"
        case beatmap = "com.zzk.cgssguide.Second"
        case event = "com.zzk.cgssguide.Third"
        case gacha = "com.zzk.cgssguide.Fourth"
    }
    
    private func handleShortcutItem(_ item: ShortcutItemType) {
        if let nvc = CGSSClient.shared.tabBarController?.selectedViewController as? UINavigationController {
            switch item {
            case .card:
                CGSSClient.shared.tabBarController?.selectedIndex = 0
                // make current navigation controller pop to root
                nvc.popToRootViewController(animated: true)
                // without this line the new selectedindex of tabbar controller's content(tableview) has a wrong content inset
                CGSSClient.shared.tabBarController?.view.setNeedsLayout()
            case .beatmap:
                CGSSClient.shared.tabBarController?.selectedIndex = 1
                nvc.popToRootViewController(animated: true)
                CGSSClient.shared.tabBarController?.view.setNeedsLayout()
            case .event:
                CGSSClient.shared.tabBarController?.selectedIndex = 3
                nvc.popToRootViewController(animated: true)
                CGSSClient.shared.tabBarController?.view.setNeedsLayout()
                if let nvc = CGSSClient.shared.tabBarController?.selectedViewController as? UINavigationController {
                    let vc = EventViewController()
                    vc.hidesBottomBarWhenPushed = true
                    nvc.pushViewController(vc, animated: true)
                }
            case .gacha:
                CGSSClient.shared.tabBarController?.selectedIndex = 3
                nvc.popToRootViewController(animated: true)
                CGSSClient.shared.tabBarController?.view.setNeedsLayout()
                if let nvc = CGSSClient.shared.tabBarController?.selectedViewController as? UINavigationController {
                    let vc = GachaViewController()
                    vc.hidesBottomBarWhenPushed = true
                    nvc.pushViewController(vc, animated: true)
                }
            }
        }
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if let type = ShortcutItemType.init(rawValue: shortcutItem.type) {
            handleShortcutItem(type)
        }
    }
    
    func registerUserNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert]) { (granted, error) in
                if error == nil {

                }
            }
        } else {
            let setting = UIUserNotificationSettings.init(types: [.badge, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        //
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //
    }
    
    private func openSpecificPageWithLocalNotification(_ notification: UILocalNotification) {
        if notification.category == NotificationCategory.birthday {
            let tabBarController = CGSSClient.shared.tabBarController
            if let nvc = tabBarController?.selectedViewController as? UINavigationController,
                let charaId = notification.userInfo?["chara_id"] as? Int,
                let char = CGSSDAO.shared.findCharById(charaId) {
                let vc = CharDetailViewController()
                vc.char = char
                vc.hidesBottomBarWhenPushed = true
                nvc.pushViewController(vc, animated: true)
            }
        }
    }
    
    // 接收到本地消息
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        openSpecificPageWithLocalNotification(notification)
    }
    
    // 接收到远程消息
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        // 每次进入前台时 规划接下来一个月的偶像生日
        if UserDefaults.standard.shouldPostBirthdayNotice {
            BirthdayCenter.default.scheduleNotifications()
        }
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        CoreDataStack.default.viewContext.refreshAllObjects()
        CoreDataStack.default.backgroundContext.refreshAllObjects()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

