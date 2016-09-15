//
//  CGSSCardIcon.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/15.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

open class CGSSCardIcon: CGSSBaseModel {
    open var card_id:Int?
    open var file_name:String?
    open var url:String?
    open var xoffset:Int?
    open var yoffset:Int?
    open var row:Int? {
        if let value = yoffset {
            return value / 48
        }
        else {
            return nil
        }
    }
    open var col:Int? {
        if let value = xoffset {
            return value / 48
        }
        else {
            return nil
        }
    }
    init(card_id:Int?, file_name:String?, url:String?, xoffset:Int?, yoffset:Int?) {
        super.init()
        self.card_id = card_id
        self.file_name = file_name
        self.url = url
        self.xoffset = xoffset
        self.yoffset = yoffset
    }
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(xoffset, forKey: "xoffset")
        aCoder.encode(yoffset, forKey: "yoffset")
        aCoder.encode(card_id, forKey: "card_id")
        aCoder.encode(file_name, forKey: "file_name")
        aCoder.encode(url, forKey: "url")
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xoffset = aDecoder.decodeObject(forKey: "xoffset") as? Int
        self.yoffset = aDecoder.decodeObject(forKey: "yoffset") as? Int
        self.file_name = aDecoder.decodeObject(forKey: "file_name") as? String
        self.card_id = aDecoder.decodeObject(forKey: "card_id") as? Int
        self.url = aDecoder.decodeObject(forKey: "url") as? String
        
    }
}
