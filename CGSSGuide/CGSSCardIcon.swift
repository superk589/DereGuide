//
//  CGSSCardIcon.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/15.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

public class CGSSCardIcon: CGSSBaseModel {
    public var card_id:Int?
    public var file_name:String?
    public var url:String?
    public var xoffset:Int?
    public var yoffset:Int?
    public var row:Int? {
        if let value = yoffset {
            return value / 48
        }
        else {
            return nil
        }
    }
    public var col:Int? {
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
    public override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(xoffset, forKey: "xoffset")
        aCoder.encodeObject(yoffset, forKey: "yoffset")
        aCoder.encodeObject(card_id, forKey: "card_id")
        aCoder.encodeObject(file_name, forKey: "file_name")
        aCoder.encodeObject(url, forKey: "url")
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xoffset = aDecoder.decodeObjectForKey("xoffset") as? Int
        self.yoffset = aDecoder.decodeObjectForKey("yoffset") as? Int
        self.file_name = aDecoder.decodeObjectForKey("file_name") as? String
        self.card_id = aDecoder.decodeObjectForKey("card_id") as? Int
        self.url = aDecoder.decodeObjectForKey("url") as? String
        
    }
}
