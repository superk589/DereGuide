//
//  CGSSSong.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/22.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

enum SongType {
    case all
    case cool
    case passion
    case cute
    init? (type: CGSSGrooveType) {
        switch type {
        case .cute:
            self = .cute
        case .cool:
            self = .cool
        case .passion:
            self = .passion
        }
    }
}

extension CGSSSong {
    var jacketURL: URL? {
        return URL.init(string: DataURL.Images + "/jacket/\(id!).png")
    }
}


open class CGSSSong: CGSSBaseModel {
    var id:Int?
    var bpm:Int?
    var title:String?
    var composer:String?
    var lyricist:String?
    
    override open func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(id, forKey: "id")
        aCoder.encode(bpm, forKey: "bpm")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(composer, forKey: "composer")
        aCoder.encode(lyricist, forKey: "lyricist")
        
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.bpm = aDecoder.decodeObject(forKey: "bpm") as? Int
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.composer = aDecoder.decodeObject(forKey: "composer") as? String
        self.lyricist = aDecoder.decodeObject(forKey: "lyricist") as? String
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
