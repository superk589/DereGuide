//
//  CGSSVersionManager.swift
//  CGSSGuide
//
//  Created by zzk on 2016/12/24.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSVersionManager {
    
    static let `default` = CGSSVersionManager()
    
    var newestDataVersion: (String, String) {
        let major = (Bundle.main.infoDictionary!["Data Version"] as! [String:String])["Major"]!
        let minor = (Bundle.main.infoDictionary!["Data Version"] as! [String:String])["Minor"]!
        return (major, minor)
    }
    
    var currentDataVersion: (String, String) {
        set {
            UserDefaults.standard.set(newValue.0, forKey: "Major")
            UserDefaults.standard.set(newValue.1, forKey: "Minor")
        }
        get {
            let major = UserDefaults.standard.object(forKey: "Major") as? String ?? "0"
            let minor = UserDefaults.standard.object(forKey: "Minor") as? String ?? "0"
            return (major, minor)
        }
    }

    var currentDataVersionString: String {
        return "\(currentDataVersion.0).\(currentDataVersion.1)"
    }
    
    // 设置当前数据版本号为最新版本
    func setVersionToNewest() {
        UserDefaults.standard.set(newestDataVersion.0, forKey: "Major")
        UserDefaults.standard.set(newestDataVersion.1, forKey: "Minor")
    }
    
    
    

    
}
