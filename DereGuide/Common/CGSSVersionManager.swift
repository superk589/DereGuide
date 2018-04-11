//
//  CGSSVersionManager.swift
//  DereGuide
//
//  Created by zzk on 2016/12/24.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

class CGSSVersionManager {
    
    static let `default` = CGSSVersionManager()
    
    var apiInfo: ApiInfo?
    
    var gameVersion: Version? {
        set {
            UserDefaults.standard.set(newValue?.description, forKey: "game_version")
        }
        get {
            if let string = UserDefaults.standard.object(forKey: "game_version") as? String {
                return Version(string: string)
            } else {
                return nil
            }
        }
    }
    
    var dataVersion: Version {
        set {
            UserDefaults.standard.set(newValue.description, forKey: "data_version")
        }
        get {
            if let string = UserDefaults.standard.object(forKey: "data_version") as? String {
                return Version(string: string) ?? Version(1, 0, 0)
            } else {
                return Version(1, 0, 0)
            }
        }
    }
    
    var minimumSupportedDataVersion: Version {
        get {
            let dataVersionString = Bundle.main.infoDictionary?["Data version"] as? String ?? "1.0.0"
            return Version(string: dataVersionString)!
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
