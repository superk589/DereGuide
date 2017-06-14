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
    
    var showRecentTeamMember: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "showRecentTeamMember")
        }
        get {
            return UserDefaults.standard.object(forKey: "showRecentTeamMember") as? Bool ?? true
        }
    }
    
    var useGridView: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "useGridView")
        }
        get {
            return UserDefaults.standard.object(forKey: "useGridView") as? Bool ?? true
        }
    }
    
    func reset() {
        defaultPotentialLevel = 25
        defaultSkillLevel = 10
        showRecentTeamMember = true
        useGridView = true
    }
}
