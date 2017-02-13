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
        return self.liveDetailId.last ?? 0
    }
    
    dynamic var createId: Int {
        return self.liveDetailId.first ?? 0
    }
    
//    dynamic var bpm: Int {
//        let dao = CGSSDAO.sharedDAO
//        return dao.findSongById(self.musicId!)?.bpm ?? 0
//    }
    
    dynamic var maxDiffStars: Int {
        return getStarsForDiff(maxDiff)
    }
    
    // 每beat占用的秒数
    var beatSec: Float {
        return 1 / Float(bpm) * 60
    }

    
    func getLiveColor() -> UIColor {
        switch type {
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
        switch type {
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
        switch type {
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
    
    var eventFilterType: CGSSLiveEventTypes {
        return CGSSLiveEventTypes.init(eventType: eventType)
    }
    
    func getStarsForDiff(_ diff: Int) -> Int {
        switch diff {
        case 1:
            return debut
        case 2:
            return regular
        case 3:
            return pro
        case 4:
            return master
        case 5:
            return masterPlus
        default:
            return 0
        }
    }
    var maxDiff: Int {
        return (self.masterPlus == 0) ? 4 : 5
    }
    
    func getBeatmapByDiff(_ diff: Int) -> CGSSBeatmap? {
        if let beatmaps = CGSSGameResource.shared.getBeatmaps(liveId: id){
            return beatmaps[diff - 1]
        } else {
            return nil
        }
    }
    
    var jacketURL: URL? {
        return URL.init(string: DataURL.Images + "/jacket/\(musicId).png")
    }
    
    var title: String {
        if eventType == 0 {
            return musicTitle
        } else {
            return musicTitle + "(" + NSLocalizedString("活动", comment: "") + ")"
        }
    }
}

open class CGSSLive: CGSSBaseModel {
    var id: Int
    var musicId: Int
    var musicTitle: String
    var type: Int
    var liveDetailId: [Int]
    var eventType: Int
    var debut: Int
    var regular: Int
    var pro: Int
    var master: Int
    var masterPlus: Int
    var bpm: Int
    
    init(id: Int,
         musicId: Int, musicTitle: String,
         type: Int,
         liveDetailId: [Int],
         eventType: Int,
         debut: Int,
         regular: Int,
         pro: Int,
         master: Int,
         masterPlus: Int,
         bpm: Int) {
        
        self.id = id
        self.musicId = musicId
        self.musicTitle = musicTitle
        self.type = type
        self.liveDetailId = liveDetailId
        self.eventType = eventType
        self.debut = debut
        self.regular = regular
        self.pro = pro
        self.master = master
        self.masterPlus = masterPlus
        self.bpm = bpm
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
