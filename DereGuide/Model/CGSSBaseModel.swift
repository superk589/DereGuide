//
//  CGSSBaseModel.swift
//  DereGuide
//
//  Created by zzk on 16/7/22.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

open class CGSSBaseModel: NSObject, NSCoding {
    
    var dataVersion: Version = CGSSVersionManager.default.dataVersion
    
    public required init?(coder aDecoder: NSCoder) {
        let versionString = aDecoder.decodeObject(forKey: "dataVersion") as? String ?? "1.0.0"
        dataVersion = Version(string: versionString) ?? Version(1, 0, 0)
    }
    
    public override init() {
        super.init()
    }
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(dataVersion.description, forKey: "dataVersion")
    }
    
    var isOldVersion: Bool {
        return (dataVersion.major, dataVersion.minor) < (CGSSVersionManager.default.dataVersion.major, CGSSVersionManager.default.dataVersion.minor)
    }
    
}
