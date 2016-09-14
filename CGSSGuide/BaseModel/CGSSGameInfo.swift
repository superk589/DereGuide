//
//  CGSSGameInfo.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

class CGSSGameInfo {
    
    var apiMajor: Int!
    var apiRevision: Int!
    var truthVersion: String!
    
    init(fromJson json: JSON!) {
        if json == nil {
            return
        }
        apiMajor = json["api_major"].intValue
        apiRevision = json["api_revision"].intValue
        truthVersion = json["truth_version"].stringValue
    }
    
}