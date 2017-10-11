//
//  DeviceInformationManager.swift
//  DereGuide
//
//  Created by zzk on 2016/12/24.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import CoreTelephony
import Reachability

class DeviceInformationManager {
    
    static let `default` = DeviceInformationManager()
    
    let appName = Config.appName

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    let dataVersion = CGSSVersionManager.default.currentDataVersionString
    
    var device: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }

    
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
            return reachability.connection.description
        } else {
            return "未知"
        }
    }
    
    func toString() -> String {
        let string = "App Information:\nApp Name: \(appName)\nApp Version: \(appVersion)\nData Version: \(dataVersion)\n\nDevice Information:\nDevice: \(device)\niOS Version: \(osVersion)\nLanguage: \(language)\nCarrier: \(carrier)\nTimezone: \(timeZone)\nConnection Status: \(connection)"
        return string
    }

}
