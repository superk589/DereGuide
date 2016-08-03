//
//  CGSSLive.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

public class CGSSLive: CGSSBaseModel {
    var id:Int?
    var musicId:Int?
    var musicTitle:String?
    var type:Int?
    var liveDetailId:[Int]?
    var eventType:Int?
    var debut:Int?
    var regular:Int?
    var pro:Int?
    var master:Int?
    var masterPlus:Int?
    var updateId:Int {
        return self.liveDetailId![0]
    }
    
    var bpm:Int? {
        let dao = CGSSDAO.sharedDAO
        return dao.findSongById(self.musicId!)?.bpm
    }
    
    var barSec:Float? {
        if bpm != nil {
            return 1 / Float(bpm!) / 60
        }
        return nil
    }
    func getStarsForDiff(diff:Int) -> Int {
        switch diff {
        case 1 :
            return debut ?? 0
        case 2:
            return regular ?? 0
        case 3:
            return pro ?? 0
        case 4:
            return master ?? 0
        case 5:
            return masterPlus ?? 0
        default:
            return 0
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.id = aDecoder.decodeObjectForKey("id") as? Int
        self.musicId = aDecoder.decodeObjectForKey("musicId") as? Int
        self.musicTitle = aDecoder.decodeObjectForKey("musicTitle") as? String
        self.type = aDecoder.decodeObjectForKey("type") as? Int
        self.liveDetailId = aDecoder.decodeObjectForKey("liveDetailId") as? [Int]
        self.eventType = aDecoder.decodeObjectForKey("eventType") as? Int
        self.debut = aDecoder.decodeObjectForKey("debut") as? Int
        self.regular = aDecoder.decodeObjectForKey("regular") as? Int
        self.pro = aDecoder.decodeObjectForKey("pro") as? Int
        self.master = aDecoder.decodeObjectForKey("master") as? Int
        self.masterPlus = aDecoder.decodeObjectForKey("masterPlus") as? Int
    }
    public override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.musicId, forKey: "musicId")
        aCoder.encodeObject(self.musicTitle, forKey: "musicTitle")
        aCoder.encodeObject(self.type, forKey: "type")
        aCoder.encodeObject(self.liveDetailId, forKey: "liveDetailId")
        aCoder.encodeObject(self.eventType, forKey: "eventType")
        aCoder.encodeObject(self.debut, forKey: "debut")
        aCoder.encodeObject(self.regular, forKey: "regular")
        aCoder.encodeObject(self.pro, forKey: "pro")
        aCoder.encodeObject(self.master, forKey: "master")
        aCoder.encodeObject(self.masterPlus, forKey: "masterPlus")        

    }
    init(json:JSON) {
        self.id = json["id"].int
        self.musicId = json["musicId"].int
        self.musicTitle = json["musicTitle"].string
        self.type = json["type"].int
        self.liveDetailId = [Int]()
        for i in json["liveDetailId"].arrayValue {
            self.liveDetailId?.append(i.intValue)
        }
        self.eventType = json["eventType"].int
        self.debut = json["debut"].int
        self.regular = json["regular"].int
        self.pro = json["pro"].int
        self.master = json["master"].int
        self.masterPlus = json["masterPlus"].int

        super.init()
    }
 
}
