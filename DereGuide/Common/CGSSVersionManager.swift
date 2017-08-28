//
//  CGSSVersionManager.swift
//  DereGuide
//
//  Created by zzk on 2016/12/24.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSVersionManager {
    
    static let `default` = CGSSVersionManager()
    
    var newestDataVersion: (Int, Int) {
        let major = (Bundle.main.infoDictionary!["Data Version"] as! [String: Int])["Major"]!
        let minor = (Bundle.main.infoDictionary!["Data Version"] as! [String: Int])["Minor"]!
        return (major, minor)
    }
    
    var currentDataVersion: (Int, Int) {
        set {
            UserDefaults.standard.set(newValue.0, forKey: "data_major")
            UserDefaults.standard.set(newValue.1, forKey: "data_minor")
        }
        get {
            let major = UserDefaults.standard.object(forKey: "data_major") as? Int ?? 0
            let minor = UserDefaults.standard.object(forKey: "data_minor") as? Int ?? 0
            return (major, minor)
        }
    }

    var currentDataVersionString: String {
        return "\(currentDataVersion.0).\(currentDataVersion.1)"
    }
    
    
    var apiInfo: ApiInfo?
    var currentApiVersion: (Int, Int) {
        set {
            UserDefaults.standard.set(newValue.0, forKey: "api_major")
            UserDefaults.standard.set(newValue.1, forKey: "api_reversion")
        }
        get {
            let major = UserDefaults.standard.object(forKey: "api_major") as? Int ?? 0
            let reversion = UserDefaults.standard.object(forKey: "api_reversion") as? Int ?? 0
            return (major, reversion)
        }

    }
    
    var currentMasterTruthVersion: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "master_truth_version")
        }
        get {
            return UserDefaults.standard.object(forKey: "master_truth_version") as? String ?? "0"
        }
    }
    
    
    var currentManifestTruthVersion: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "manifest_truth_version")
        }
        get {
            return UserDefaults.standard.object(forKey: "manifest_truth_version") as? String ?? "0"
        }
    }
    
    
    // 设置当前版本号为最新版本
    func setDataVersionToNewest() {
        currentDataVersion = newestDataVersion
    }
    
    
    func setApiVersionToNewest() {
        if let info = apiInfo {
            currentApiVersion = info.apiVersion
        }
    }
    
    func setMasterTruthVersionToNewest() {
        if let info = apiInfo {
            currentMasterTruthVersion = info.truthVersion
        }
    }
    
    func setManifestTruthVersionToNewest() {
        if let info = apiInfo {
            currentManifestTruthVersion = info.truthVersion
        }
    }
}
