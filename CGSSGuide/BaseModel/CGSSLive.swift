//
//  CGSSLive.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

enum CGSSLiveType: String {
    case Normal = "常规模式"
    case VocalBurstGroove = "Vocal Burst"
    case DanceBurstGroove = "Dance Burst"
    case VisualBurstGroove = "Visual Burst"
    static func getAll() -> [CGSSLiveType] {
        return [.Normal, .VocalBurstGroove, .DanceBurstGroove, .VisualBurstGroove]
    }
    func typeColor() -> UIColor {
        switch self {
        case .Normal:
            return CGSSGlobal.allTypeColor
        case .VocalBurstGroove:
            return CGSSGlobal.vocalColor
        case .DanceBurstGroove:
            return CGSSGlobal.danceColor
        case .VisualBurstGroove:
            return CGSSGlobal.passionColor
        }
    }
}

enum CGSSGrooveType: String {
    case Cute = "Cute Groove"
    case Cool = "Cool Groove"
    case Passion = "Passion Groove"
    static func getAll() -> [CGSSGrooveType] {
        return [.Cute, .Cool, .Passion]
    }
    init? (type: CGSSCardFilterType) {
        switch type {
        case .Cute:
            self = .Cute
        case .Cool:
            self = .Cool
        case .Passion:
            self = .Passion
        case .Office:
            return nil
        }
    }
    func typeColor() -> UIColor {
        switch self {
        case .Cute:
            return CGSSGlobal.cuteColor
        case .Cool:
            return CGSSGlobal.coolColor
        case .Passion:
            return CGSSGlobal.passionColor
        }
    }
}

extension CGSSLive {
    // 用于排序的属性
    dynamic var updateId: Int {
        return self.liveDetailId![0]
    }
    
    dynamic var bpm: Int {
        let dao = CGSSDAO.sharedDAO
        return dao.findSongById(self.musicId!)?.bpm ?? 0
    }
    
    dynamic var maxDiffStars: Int {
        return getStarsForDiff(maxDiff)
    }
    
    var musicRef: CGSSSong? {
        return CGSSDAO.sharedDAO.findSongById(musicId!)
    }
    
    var barSec: Float {
        return 1 / Float(bpm) / 60
    }
    
    func getLiveColor() -> UIColor {
        switch type! {
        case 1:
            return CGSSGlobal.cuteColor
        case 2:
            return CGSSGlobal.coolColor
        case 3:
            return CGSSGlobal.passionColor
        default:
            return UIColor.darkTextColor()
        }
    }
    func getLiveIconName() -> String {
        switch type! {
        case 1:
            return "song_cute"
        case 2:
            return "song_cool"
        case 3:
            return "song_passion"
        default:
            return "song_all"
        }
        
    }
    
    var songType: CGSSCardFilterType {
        switch type! {
        case 1:
            return .Cute
        case 2:
            return .Cool
        case 3:
            return .Passion
        default:
            return .Office
        }
    }
    
    var eventFilterType: CGSSSongEventFilterType {
        return CGSSSongEventFilterType.init(eventType: eventType!)
    }
    
    func getStarsForDiff(diff: Int) -> Int {
        switch diff {
        case 1:
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
    var maxDiff: Int {
        return (self.masterPlus == 0) ? 4 : 5
    }
    
}

public class CGSSLive: CGSSBaseModel {
    var id: Int?
    var musicId: Int?
    var musicTitle: String?
    var type: Int?
    var liveDetailId: [Int]?
    var eventType: Int?
    var debut: Int?
    var regular: Int?
    var pro: Int?
    var master: Int?
    var masterPlus: Int?
    
    func getBeatmapByDiff(diff: Int) -> CGSSBeatmap? {
        return CGSSDAO.sharedDAO.findBeatmapById(self.id!, diffId: diff)
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
    init(json: JSON) {
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
