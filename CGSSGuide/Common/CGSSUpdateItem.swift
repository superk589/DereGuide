//
//  CGSSUpdateItem.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/21.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

public enum CGSSUpdateDataType:UInt {
    case card = 1
    case cardIcon = 2
    case song = 4
    case live = 8
    case beatmap = 16
    case story = 32
    case resource = 64
}

class CGSSUpdateItem: NSObject {

    var dataType:CGSSUpdateDataType
    var data:Data?
    var complete:((CGSSUpdateItem)->Void)?
    var id:String
    
    init(dataType:CGSSUpdateDataType, id:String) {
        self.dataType = dataType
        self.id = id
        super.init()
    }
}
