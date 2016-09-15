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
        case .cute:
            self = .Cute
        case .cool:
            self = .Cool
        case .passion:
            self = .Passion
        case .office:
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
            return UIColor.darkText
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
            return .cute
        case 2:
            return .cool
        case 3:
            return .passion
        default:
            return .office
        }
    }
    
    var eventFilterType: CGSSSongEventFilterType {
        return CGSSSongEventFilterType.init(eventType: eventType!)
    }
    
    func getStarsForDiff(_ diff: Int) -> Int {
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

open class CGSSLive: CGSSBaseModel {
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
    
    func getBeatmapByDiff(_ diff: Int) -> CGSSBeatmap? {
        return CGSSDAO.sharedDAO.findBeatmapById(self.id!, diffId: diff)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.musicId = aDecoder.decodeObject(forKey: "musicId") as? Int
        self.musicTitle = aDecoder.decodeObject(forKey: "musicTitle") as? String
        self.type = aDecoder.decodeObject(forKey: "type") as? Int
        self.liveDetailId = aDecoder.decodeObject(forKey: "liveDetailId") as? [Int]
        self.eventType = aDecoder.decodeObject(forKey: "eventType") as? Int
        self.debut = aDecoder.decodeObject(forKey: "debut") as? Int
        self.regular = aDecoder.decodeObject(forKey: "regular") as? Int
        self.pro = aDecoder.decodeObject(forKey: "pro") as? Int
        self.master = aDecoder.decodeObject(forKey: "master") as? Int
        self.masterPlus = aDecoder.decodeObject(forKey: "masterPlus") as? Int
    }
    open override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.musicId, forKey: "musicId")
        aCoder.encode(self.musicTitle, forKey: "musicTitle")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.liveDetailId, forKey: "liveDetailId")
        aCoder.encode(self.eventType, forKey: "eventType")
        aCoder.encode(self.debut, forKey: "debut")
        aCoder.encode(self.regular, forKey: "regular")
        aCoder.encode(self.pro, forKey: "pro")
        aCoder.encode(self.master, forKey: "master")
        aCoder.encode(self.masterPlus, forKey: "masterPlus")
        
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
