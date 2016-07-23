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
    //var liveDetailId:[Int]?
    var eventType:Int?
    var debut:Int?
    var regular:Int?
    var pro:Int?
    var master:Int?
    var masterPlus:Int?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.id = aDecoder.decodeObjectForKey("id") as? Int
        self.musicId = aDecoder.decodeObjectForKey("musicId") as? Int
        self.musicTitle = aDecoder.decodeObjectForKey("musicTitle") as? String
        self.type = aDecoder.decodeObjectForKey("type") as? Int
        //self.liveDetailId = aDecoder.decodeObjectForKey("liveDetailId") as?
        self.eventType = aDecoder.decodeObjectForKey("eventType") as? Int
        self.debut = aDecoder.decodeObjectForKey("debut") as? Int
        self.regular = aDecoder.decodeObjectForKey("regular") as? Int
        self.pro = aDecoder.decodeObjectForKey("pro") as? Int
        self.master = aDecoder.decodeObjectForKey("master") as? Int
        self.masterPlus = aDecoder.decodeObjectForKey("masterPlus") as? Int
    }
    init(json:JSON) {
        self.id = json["id"].int
        self.musicId = json["musicId"].int
        self.musicTitle = json["musicTitle"].string
        self.type = json["type"].int
//        self.liveDetailId = [Int]()
//        for i in json["liveDetailId"].arrayValue {
//            self.liveDetailId?.append(i.intValue)
//        }
        self.eventType = json["eventType"].int
        self.debut = json["debut"].int
        self.regular = json["regular"].int
        self.pro = json["pro"].int
        self.master = json["master"].int
        self.masterPlus = json["masterPlus"].int

        super.init()
    }
 
}
