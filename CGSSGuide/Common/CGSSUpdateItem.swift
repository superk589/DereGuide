//
//  CGSSUpdateItem.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/21.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

public enum CGSSUpdateDataType:UInt {
    case Card = 1
    case CardIcon = 2
    case Song = 4
    case Live = 8
    case Beatmap = 16
    case Story = 32
    case Resource = 64
}

class CGSSUpdateItem: NSObject {

    var dataType:CGSSUpdateDataType
    var data:NSData?
    var complete:((CGSSUpdateItem)->Void)?
    var id:String
    
    init(dataType:CGSSUpdateDataType, id:String) {
        self.dataType = dataType
        self.id = id
        super.init()
    }
}
