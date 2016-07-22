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
    case Song = 2
    case Story = 4
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
