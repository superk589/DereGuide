//
//  CGSSSong.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/22.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

public class CGSSSong: CGSSBaseModel {
    var id:Int?
    var bpm:Int?
    var title:String?
    var composer:String?
    var lyricist:String?
    
    override public func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(bpm, forKey: "bpm")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(composer, forKey: "composer")
        aCoder.encodeObject(lyricist, forKey: "lyricist")
        
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.id = aDecoder.decodeObjectForKey("id") as? Int
        self.bpm = aDecoder.decodeObjectForKey("bpm") as? Int
        self.title = aDecoder.decodeObjectForKey("title") as? String
        self.composer = aDecoder.decodeObjectForKey("composer") as? String
        self.lyricist = aDecoder.decodeObjectForKey("lyricist") as? String
    }
    init?(id:Int, bpm:Int, title:String, composer:String, lyricist:String) {
        self.id = id
        self.bpm = bpm
        self.title = title
        self.composer = composer
        self.lyricist = lyricist
        super.init()
    }
    init(json:JSON) {
        self.id = json["id"].int
        self.bpm = json["bpm"].int
        self.composer = json["composer"].string
        self.lyricist = json["lyricist"].string
        self.title = json["title"].string
        super.init()
    }
}
