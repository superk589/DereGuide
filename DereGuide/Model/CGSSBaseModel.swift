//
//  CGSSBaseModel.swift
//  DereGuide
//
//  Created by zzk on 16/7/22.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

open class CGSSBaseModel: NSObject, NSCoding {
    var dataVersion: (Int, Int)
    var updateTime: Date
    var apiVersion: (Int, Int)
    public override init() {
        self.dataVersion = CGSSVersionManager.default.newestDataVersion
        self.apiVersion = CGSSVersionManager.default.apiInfo?.apiVersion ?? (0, 0)
        self.updateTime = Date()
        super.init()
    }
    public required init?(coder aDecoder: NSCoder) {
        self.dataVersion.0 = aDecoder.decodeInteger(forKey: "data_major")
        self.dataVersion.1 = aDecoder.decodeInteger(forKey: "data_minor")
        self.updateTime = aDecoder.decodeObject(forKey: "update_time") as? Date ?? Date()
        self.apiVersion = (aDecoder.decodeInteger(forKey: "api_version_major"), aDecoder.decodeInteger(forKey: "api_version_reversion"))
    }
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(dataVersion.0, forKey: "data_major")
        aCoder.encode(self.dataVersion.1, forKey: "data_minor")
        aCoder.encode(self.updateTime, forKey: "update_time")
        aCoder.encode(self.apiVersion.0, forKey: "api_version_major")
        aCoder.encode(self.apiVersion.1, forKey: "api_version_reversion")
    }
    var isOldVersion: Bool {
        return self.apiVersion < (CGSSVersionManager.default.apiInfo?.apiVersion ?? (0, 0)) || self.dataVersion < CGSSVersionManager.default.newestDataVersion
    }
}
