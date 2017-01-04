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
    case normal = "常规模式" //!!!无法被本地化 注意使用时本地化
    case vocal = "Vocal Burst"
    case dance = "Dance Burst"
    case visual = "Visual Burst"
    case parade = "LIVE Parade"
    static func getAll() -> [CGSSLiveType] {
        return [.normal, .vocal, .dance, .visual, .parade]
    }
    func typeColor() -> UIColor {
        switch self {
        case .normal:
            return Color.allType
        case .vocal:
            return Color.vocal
        case .dance:
            return Color.dance
        case .visual:
            return Color.passion
        case .parade:
            return Color.parade
        }
    }
    func toString() -> String {
        switch self {
        case .normal:
            return NSLocalizedString("常规模式", comment: "")
        default:
            return self.rawValue
        }
    }
}

enum CGSSGrooveType: String {
    case cute = "Cute Groove"
    case cool = "Cool Groove"
    case passion = "Passion Groove"
    static func getAll() -> [CGSSGrooveType] {
        return [.cute, .cool, .passion]
    }
    func typeColor() -> UIColor {
        switch self {
        case .cute:
            return Color.cute
        case .cool:
            return Color.cool
        case .passion:
            return Color.passion
        }
    }
    init? (cardType: CGSSCardTypes) {
        switch cardType {
        case CGSSCardTypes.cute:
            self = .cute
        case CGSSCardTypes.cool:
            self = .cool
        case CGSSCardTypes.passion:
            self = .passion
        default:
            return nil
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
    
    // 每beat占用的秒数
    var beatSec: Float {
        return 1 / Float(bpm) * 60
    }

    
    func getLiveColor() -> UIColor {
        switch type! {
        case 1:
            return Color.cute
        case 2:
            return Color.cool
        case 3:
            return Color.passion
        default:
            return UIColor.darkText
        }
    }
    func getLiveIconName() -> String {
        switch type! {
        case 1:
            return "song-cute"
        case 2:
            return "song-cool"
        case 3:
            return "song-passion"
        default:
            return "song-all"
        }
        
    }
    
    var songType: CGSSCardTypes {
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
    
    var eventFilterType: CGSSSongEventTypes {
        return CGSSSongEventTypes.init(eventType: eventType!)
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
    var id: Int!
    var musicId: Int!
    var musicTitle: String!
    var type: Int!
    var liveDetailId: [Int]!
    var eventType: Int!
    var debut: Int!
    var regular: Int!
    var pro: Int!
    var master: Int!
    var masterPlus: Int!
    
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
        self.id = json["id"].intValue
        self.musicId = json["musicId"].intValue
        self.musicTitle = json["musicTitle"].stringValue
        self.type = json["type"].intValue
        self.liveDetailId = [Int]()
        for i in json["liveDetailId"].arrayValue {
            self.liveDetailId?.append(i.intValue)
        }
        self.eventType = json["eventType"].intValue
        self.debut = json["debut"].intValue
        self.regular = json["regular"].intValue
        self.pro = json["pro"].intValue
        self.master = json["master"].intValue
        self.masterPlus = json["masterPlus"].intValue
        super.init()
    }
    
}
