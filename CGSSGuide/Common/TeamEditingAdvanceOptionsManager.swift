//
//  TeamEditingAdvanceOptionsManager.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/14.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

class TeamEditingAdvanceOptionsManager {
    
    static let `default` = TeamEditingAdvanceOptionsManager()
    
    private init() {
        
    }
    
    var defaultSkillLevel: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "defaultSkillLevel")
        }
        get {
            return UserDefaults.standard.object(forKey: "defaultSkillLevel") as? Int ?? 10
        }
    }
    
    var defaultPotentialLevel: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "defaultPotentialLevel")
        }
        get {
            return UserDefaults.standard.object(forKey: "defaultPotentialLevel") as? Int ?? 25
        }
    }
    
    var includeGuestLeaderInRecentUsedIdols: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "includeGuestLeaderInRecentUsedIdols")
        }
        get {
            return UserDefaults.standard.object(forKey: "includeGuestLeaderInRecentUsedIdols") as? Bool ?? false
        }
    }
    
    var editAllSameChara: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "editAllSameChara")
        }
        get {
            return UserDefaults.standard.object(forKey: "editAllSameChara") as? Bool ?? true
        }
    }
    
    func reset() {
        defaultPotentialLevel = 25
        defaultSkillLevel = 10
        includeGuestLeaderInRecentUsedIdols = false
        editAllSameChara = true
    }
}
