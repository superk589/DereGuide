//
//  DeviceInformationManager.swift
//  CGSSGuide
//
//  Created by zzk on 2016/12/24.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import CoreTelephony
import ReachabilitySwift

class DeviceInformationManager {
    
    static let `default` = DeviceInformationManager()
    
    
    let appName = "CGSSGuide"

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    let dataVersion = CGSSVersionManager.default.currentDataVersionString
    
    let device = UIDevice.current.model
    
    let osVersion = UIDevice.current.systemVersion
    
    let language: String = Locale.current.identifier
    
    var carrier: String {
        let info = CTTelephonyNetworkInfo.init()
        return info.subscriberCellularProvider?.carrierName ?? ""
    }
    
    var timeZone: String {
        return TimeZone.current.abbreviation() ?? ""
    }
    
    var connection: String {
        if let reachability = Reachability.init(hostname: "https://www.baidu.com") {
            return reachability.currentReachabilityString
        } else {
            return "未知"
        }
    }
    
    func toString() -> String {
        let string = "App Information:\nApp Name: \(appName)\nApp Version: \(appVersion)\nData Version: \(dataVersion)\n\nDevice Information:\nDevice: \(device)\niOS Version: \(osVersion)\nLanguage: \(language)\nCarrier: \(carrier)\nTimezone: \(timeZone)\nConnection Status: \(connection)"
        return string
    }

}
