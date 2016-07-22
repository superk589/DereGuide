//
//  CGSSBaseModel.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/22.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

public class CGSSBaseModel: NSObject, NSCoding {
    var major:String!
    var minor:String!
    public override init() {
        super.init()
        self.major = CGSSUpdater.defaultUpdater.checkNewestDataVersion().0
        self.minor = CGSSUpdater.defaultUpdater.checkNewestDataVersion().1
    }
    public required init?(coder aDecoder: NSCoder) {
        self.major = aDecoder.decodeObjectForKey("major") as? String ?? CGSSUpdater.defaultUpdater.checkCurrentDataVersion().0
        self.minor = aDecoder.decodeObjectForKey("minor") as? String ?? CGSSUpdater.defaultUpdater.checkCurrentDataVersion().1
    }
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.major, forKey: "major")
        aCoder.encodeObject(self.minor, forKey: "minor")
    }
    func isOldVersion() -> Bool {
        if self.major < CGSSUpdater.defaultUpdater.checkNewestDataVersion().0 {
            return true
        } else if self.minor < CGSSUpdater.defaultUpdater.checkNewestDataVersion().1 {
            return true
        }
        return false
    }
}
