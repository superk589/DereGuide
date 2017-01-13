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

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 处理一系列启动任务
        
        // 更新时清理过期的文档数据
        UserDefaults.standard.executeDocumentReset {
            try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.songFilterPath)
            try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.cardFilterPath)
            try? FileManager.default.removeItem(atPath: CGSSSorterFilterManager.teamCardFilterPath)
        }
        
        // 规划近期偶像生日
        if UserDefaults.standard.shouldPostBirthdayNotice {
            BirthdayCenter.defaultCenter.scheduleNotifications()
        }
        
        // 设置SDWebImage过期时间
        SDImageCache.shared().maxCacheAge = 60 * 60 * 24 * 365 * 10 // 10年缓存时间
        
        // 初始化DrawerController和TabBarController
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let baseTabBarController = sb.instantiateViewController(withIdentifier: "RootTabBarViewController")
        window = UIWindow()
        let drawerController = ZKDrawerController.init(main: baseTabBarController)
        drawerController.drawerStyle = .cover
        drawerController.gestureRecognizerWidth = 80
        window?.rootViewController = drawerController
        window?.makeKeyAndVisible()
        CGSSClient.shared.drawerController = drawerController
        return true
    }
    
    func registerAPNS() {
//		let device = UIDevice.currentDevice().systemVersion
        let setting = UIUserNotificationSettings.init(types: [.sound, .alert, .badge], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(setting)
        // UIApplication.sharedApplication().registerForRemoteNotifications()
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
    
    // 接收到本地消息
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
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
            BirthdayCenter.defaultCenter.scheduleNotifications()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

