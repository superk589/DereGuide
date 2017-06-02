//
//  LiveSimulationAdvanceOptionsManager.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/3.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class LiveSimulationAdvanceOptionsManager {

    static let `default` = LiveSimulationAdvanceOptionsManager()
    
    private init() {
        
    }
    
    var considerOverloadSkillsTriggerLifeCondition: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "considerOverloadSkillsTriggerLifeCondition")
        }
        get {
            return UserDefaults.standard.bool(forKey: "considerOverloadSkillsTriggerLifeCondition")
        }
    }
    
    var roomUpValue: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "roomUpValue")
        }
        get {
            return UserDefaults.standard.object(forKey: "roomUpValue") as? Int ?? 10
        }
    }
    
    var greatPercent: Double {
        set {
            UserDefaults.standard.set(newValue, forKey: "greatPercent")
        }
        get {
            return UserDefaults.standard.double(forKey: "greatPercent")
        }
    }
    
    var simulationTimes: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "simulationTimes")
        }
        get {
            return UserDefaults.standard.object(forKey: "simulationTimes") as? Int ?? 10000
        }
    }
    
    func reset() {
        considerOverloadSkillsTriggerLifeCondition = false
        greatPercent = 0.0
        simulationTimes = 10000
        roomUpValue = 10
    }

}
