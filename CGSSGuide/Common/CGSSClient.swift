//
//  CGSSClient.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/9.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController

class CGSSClient {

    static let shared = CGSSClient()
    
    private init() {
        
    }
    var searchDebouncer = Debouncer(interval: 0.5)
    var drawerController: ZKDrawerController?
    var tabBarController: UITabBarController?
}
