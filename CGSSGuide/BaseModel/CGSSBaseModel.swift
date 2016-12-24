//
//  CGSSBaseModel.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/22.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

open class CGSSBaseModel: NSObject, NSCoding {
    var major:String!
    var minor:String!
    var updateTime:Date!
    public override init() {
        super.init()
        self.major = CGSSVersionManager.default.newestDataVersion.0
        self.minor = CGSSVersionManager.default.newestDataVersion.1
        self.updateTime = Date()
    }
    public required init?(coder aDecoder: NSCoder) {
        self.major = aDecoder.decodeObject(forKey: "major") as? String ?? CGSSVersionManager.default.currentDataVersion.0
        self.minor = aDecoder.decodeObject(forKey: "minor") as? String ?? CGSSVersionManager.default.currentDataVersion.1
        self.updateTime = aDecoder.decodeObject(forKey: "update_time") as? Date ?? Date()
    }
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.major, forKey: "major")
        aCoder.encode(self.minor, forKey: "minor")
        aCoder.encode(self.updateTime, forKey: "update_time")
    }
    var isOldVersion: Bool {
        if self.major < CGSSVersionManager.default.newestDataVersion.0 {
            return true
        } else if self.minor < CGSSVersionManager.default.newestDataVersion.1 {
            return true
        }
        return false
    }
}
