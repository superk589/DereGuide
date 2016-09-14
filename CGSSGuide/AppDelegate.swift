//
//  AppDelegate.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/3.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SDWebImage

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 处理一系列启动任务
        // 规划近期偶像生日
        if NSUserDefaults.standardUserDefaults().shouldPostBirthdayNotice {
            BirthdayCenter.defaultCenter.scheduleNotifications()
        }
        // 设置SDWebImage过期时间
        SDImageCache.sharedImageCache().maxCacheAge = 60 * 60 * 24 * 365 * 10 // 10年缓存时间
        
        return true
    }
    
    func registerAPNS() {
//		let device = UIDevice.currentDevice().systemVersion
        let setting = UIUserNotificationSettings.init(forTypes: [.Sound, .Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(setting)
        // UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        //
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        //
    }
    
    // 接收到本地消息
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
    }
    
    // 接收到远程消息
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject]) {
        
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        // 每次进入前台时 规划接下来一个月的偶像生日
        if NSUserDefaults.standardUserDefaults().shouldPostBirthdayNotice {
            BirthdayCenter.defaultCenter.scheduleNotifications()
        }
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

