//
//  CGSSLive.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

enum CGSSLiveSimulatorType: String {
    case normal = "常规模式" //!!!无法被本地化 注意使用时本地化
    case vocal = "Vocal Burst"
    case dance = "Dance Burst"
    case visual = "Visual Burst"
    case parade = "LIVE Parade"
    static func getAll() -> [CGSSLiveSimulatorType] {
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
        return beatmapCount == 5 ? masterPlusDetailId : masterDetailId
    }
    
    dynamic var createId: Int {
        return self.debutDetailId
    }
    
    dynamic var maxDiffStars: Int {
        return getStarsForDiff(maxDiff)
    }
    
    // 每beat占用的秒数
    var barSecond: Double {
        return 1 / Double(bpm) * 60
    }

    var color: UIColor {
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
    
    var icon: UIImage {
        switch type {
        case 1:
            return #imageLiteral(resourceName: "song-cute")
        case 2:
            return #imageLiteral(resourceName: "song-cool")
        case 3:
            return #imageLiteral(resourceName: "song-passion")
        default:
            return #imageLiteral(resourceName: "song-all")
        }
    }
    
    var filterType: CGSSLiveTypes {
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
            return debutDifficulty
        case 2:
            return regularDifficulty
        case 3:
            return proDifficulty
        case 4:
            return masterDifficulty
        case 5:
            return masterPlusDifficulty
        default:
            return 0
        }
    }
    
    // 最大难度, 只返回真实存在的难度
    var maxDiff: Int {
        return beatmapCount
    }
    
    // 合理的谱面数量, 包含官方还未发布的难度
    var validBeatmapCount: Int {
        return self.masterPlusDetailId == 0 ? 4 : 5
    }
    
    func getBeatmapByDiff(_ diff: Int) -> CGSSBeatmap? {
        if let beatmaps = CGSSGameResource.shared.getBeatmaps(liveId: id){
            return beatmaps[diff - 1]
        } else {
            return nil
        }
    }
    
    var jacketURL: URL? {
        return URL.init(string: DataURL.Images + "/jacket/\(musicDataId).png")
    }
    
    var title: String {
        if eventType == 0 {
            return name
        } else {
            return name + "(" + NSLocalizedString("活动", comment: "") + ")"
        }
    }
}


class CGSSLive: CGSSBaseModel {
    
    var bpm : Int
    var charaPosition1 : Int
    var charaPosition2 : Int
    var charaPosition3 : Int
    var charaPosition4 : Int
    var charaPosition5 : Int
    var composer : String
    var debutDetailId : Int
    var debutDifficulty : Int
    var eventType : Int
    var id : Int
    var lyricist : String
    var masterDetailId : Int
    var masterDifficulty : Int
    var masterPlusDetailId : Int
    var masterPlusDifficulty : Int
    var musicDataId : Int
    var name : String
    var positionNum : Int
    var proDetailId : Int
    var proDifficulty : Int
    var regularDetailId : Int
    var regularDifficulty : Int
    var startDate : String
    var type : Int

    lazy var beatmapCount: Int = {
        let semaphore = DispatchSemaphore.init(value: 0)
        var result = 0
        
        let path = String.init(format: DataPath.beatmap, self.id)
        let fm = FileManager.default
        if fm.fileExists(atPath: path), let dbQueue = MusicScoreDBQueue.init(path: path) {
            dbQueue.getBeatmapCount(callback: { (count) in
                result = count
                semaphore.signal()
            })
        } else {
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }()
    
    lazy var vocalists: [Int] = {
        let semaphore = DispatchSemaphore(value: 0)
        var result = [Int]()
        CGSSGameResource.shared.master.getVocalistsBy(musicDataId: self.musicDataId, callback: { (list) in
            result = list
            semaphore.signal()
        })
        semaphore.wait()
        return result
    }()
    
    lazy dynamic var maxNumberOfNotes: Int = {
        return self.getBeatmapByDiff(self.maxDiff)?.numberOfNotes ?? 0
    }()
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init? (fromJson json: JSON){
        if json.isEmpty {
            return nil
        }
        bpm = json["bpm"].intValue
        charaPosition1 = json["chara_position_1"].intValue
        charaPosition2 = json["chara_position_2"].intValue
        charaPosition3 = json["chara_position_3"].intValue
        charaPosition4 = json["chara_position_4"].intValue
        charaPosition5 = json["chara_position_5"].intValue
        composer = json["composer"].stringValue
        debutDetailId = json["debut_detail_id"].intValue
        debutDifficulty = json["debut_difficulty"].intValue
        eventType = json["event_type"].intValue
        id = json["id"].intValue
        lyricist = json["lyricist"].stringValue
        masterDetailId = json["master_detail_id"].intValue
        masterDifficulty = json["master_difficulty"].intValue
        masterPlusDetailId = json["master_plus_detail_id"].intValue
        masterPlusDifficulty = json["master_plus_difficulty"].intValue
        musicDataId = json["music_data_id"].intValue
        name = json["name"].stringValue
        positionNum = json["position_num"].intValue
        proDetailId = json["pro"].intValue
        proDifficulty = json["pro_difficulty"].intValue
        regularDetailId = json["regular_detail_id"].intValue
        regularDifficulty = json["regular_difficulty"].intValue
        startDate = json["start_date"].stringValue
        type = json["type"].intValue
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
