//
//  AppDelegate.swift
//  DereGuide
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
    
    var syncCoordinator: SyncCoordinator!
    
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
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.SorterPath.unitCard)
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.SorterPath.live)
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.SorterPath.char)
            }
            if lastVersion < 3 {
                CGSSCacheManager.shared.wipeLive()
            }
            if lastVersion < 7 {
                let context = CoreDataStack.default.viewContext
                for cardID in CGSSFavoriteManager.default.favoriteCards {
                    FavoriteCard.insert(into: context, cardID: cardID)
                }
                for charaID in CGSSFavoriteManager.default.favoriteChars {
                    FavoriteChara.insert(into: context, charaID: charaID)
                }
                context.saveOrRollback()
            }
            if lastVersion < 9 {
                CGSSCacheManager.shared.wipeUserDocuments()
                try? FileManager.default.removeItem(atPath: CGSSDAO.path + "/Data/")
            }
            if lastVersion < 11 {
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.FilterPath.live)
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.FilterPath.unitLive)
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.SorterPath.live)
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.SorterPath.unitLive)
            }
            if lastVersion < 12 {
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.FilterPath.card)
                try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.FilterPath.unitCard)
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
        CGSSClient.shared.tabBarController = rootTabBarController
        
        // 判断是否通过本地消息进入, 如果是跳转到指定页面
        if let notification = launchOptions?[.localNotification] as? UILocalNotification {
            openSpecificPageWithLocalNotification(notification)
        }
        
        // 注册远程推送 用于订阅CloudKit同步信息
        application.registerForRemoteNotifications()

        // 同步协调器获取最新的远端数据
        SyncCoordinator.shared.applicationDidFinishLaunching()
        
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
                    nvc.navigationBar.setNeedsLayout()
                }
            case .gacha:
                CGSSClient.shared.tabBarController?.selectedIndex = 3
                nvc.popToRootViewController(animated: true)
                CGSSClient.shared.tabBarController?.view.setNeedsLayout()
                if let nvc = CGSSClient.shared.tabBarController?.selectedViewController as? UINavigationController {
                    let vc = GachaViewController()
                    vc.hidesBottomBarWhenPushed = true
                    nvc.pushViewController(vc, animated: true)
                    nvc.navigationBar.setNeedsLayout()
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
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert]) { (granted, error) in
                if error == nil {

                }
            }
        } else {
            let setting = UIUserNotificationSettings.init(types: [.sound, .badge, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        //
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let drawer = window?.rootViewController as? ZKDrawerController, let center = drawer.centerViewController as? UITabBarController, let nav = center.selectedViewController as? UINavigationController, let topmost = nav.topViewController {
            if topmost is BeatmapViewController {
                return .all
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        } else {
            return .portrait
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
        // 删除已经被标记为本地删除的对象
        CoreDataStack.default.syncContext.perform {
            CoreDataStack.default.syncContext.deleteObjectsMarkedForLocalDeletion()
            CoreDataStack.default.syncContext.refreshAllObjects()
        }
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        CoreDataStack.default.viewContext.refreshAllObjects()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("register remote notification success")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("register remote notfication failed")
    }
    
    private func openSpecificPageWithLocalNotification(_ notification: UILocalNotification) {
        if notification.category == NotificationCategory.birthday {
            let tabBarController = CGSSClient.shared.tabBarController
            if let nvc = tabBarController?.selectedViewController as? UINavigationController,
                let charaId = notification.userInfo?["chara_id"] as? Int,
                let chara = CGSSDAO.shared.findCharById(charaId) {
                let vc = CharDetailViewController()
                vc.chara = chara
                vc.hidesBottomBarWhenPushed = true
                nvc.pushViewController(vc, animated: true)
                nvc.navigationBar.setNeedsLayout()
            }
        }
    }
    
    // 接收到本地消息
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        openSpecificPageWithLocalNotification(notification)
    }
    
    // 接收到远程消息
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        //
    }
    
    // 接受CloudKit Subscription
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let info = userInfo as? [String: NSObject] else { return }
        SyncCoordinator.shared.application(application, didReceiveRemoteNotification: info)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        // 每次进入前台时 规划接下来一个月的偶像生日
        if UserDefaults.standard.shouldPostBirthdayNotice {
            BirthdayCenter.default.scheduleNotifications()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

