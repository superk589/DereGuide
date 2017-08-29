//
//  CGSSLive.swift
//  DereGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

enum CGSSLiveSimulatorType: String, CustomStringConvertible, ColorRepresentable {
    case normal = "常规模式" //!!!无法被本地化 注意使用时本地化
    case vocal = "Vocal Burst"
    case dance = "Dance Burst"
    case visual = "Visual Burst"
    case parade = "LIVE Parade"
    static let all: [CGSSLiveSimulatorType] = [.normal, .vocal, .dance, .visual, .parade]
    
    var color: UIColor {
        switch self {
        case .normal:
            return Color.dance
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
    
    var description: String {
        switch self {
        case .normal:
            return NSLocalizedString("常规模式", comment: "")
        default:
            return self.rawValue
        }
    }
}

enum CGSSGrooveType: String, CustomStringConvertible, ColorRepresentable {
    case cute = "Cute Groove"
    case cool = "Cool Groove"
    case passion = "Passion Groove"
    static let all: [CGSSGrooveType] = [.cute, .cool, .passion]
    
    var description: String {
        return self.rawValue
    }
    
    var color: UIColor {
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


// MARK: 用于排序的属性
extension CGSSLive {
    @objc dynamic var updateId: Int {
        return beatmapCount == 5 ? self[.masterPlus].id : self[.master].id
    }
    
    @objc dynamic var createId: Int {
        return self[.debut].id
    }
    
    @objc dynamic var maxDiffStars: Int {
        return self[selectableMaxDifficulty].stars
    }
    
    @objc dynamic var maxNumberOfNotes: Int {
        return liveDetails[selectableMaxDifficulty.rawValue - 1].numberOfNotes
        // this method takes very long time, because it read each beatmap files
//        return self.getBeatmap(of: selectableMaxDifficulty)?.numberOfNotes ?? 0
    }
}

extension CGSSLive {
    
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
    
    func getStarsForDiff(_ difficulty: CGSSLiveDifficulty) -> Int {
        return liveDetails[difficulty.rawValue - 1].stars
    }
    
    // 最大难度, 只返回真实存在的难度
    var maxDiff: CGSSLiveDifficulty {
        return CGSSLiveDifficulty(rawValue: beatmapCount) ?? .masterPlus
    }
    
    // filter 之后, 可以选择的最大难度
    var selectableMaxDifficulty: CGSSLiveDifficulty {
        guard let max = difficultyTypes.max,
            let maxDifficulty = CGSSLiveDifficulty(rawValue: min(max.rawValue, maxDiff.rawValue)) else {
                return maxDiff
        }
        return maxDifficulty
    }
    
    // 合理的谱面数量, 包含官方还未发布的难度
    var validBeatmapCount: Int {
        return self.getLiveDetail(of: .masterPlus).id == 0 ? 4 : 5
    }
    
    func getBeatmap(of difficulty: CGSSLiveDifficulty) -> CGSSBeatmap? {
        if beatmaps.count >= difficulty.rawValue {
            return beatmaps[difficulty.rawValue - 1]
        } else {
            return nil
        }
    }
    
    func getLiveDetail(of difficulty: CGSSLiveDifficulty) -> CGSSLiveDetail {
        return self.liveDetails[difficulty.rawValue - 1]
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
    
    subscript (difficulty: CGSSLiveDifficulty) -> CGSSLiveDetail {
        get {
            return getLiveDetail(of: difficulty)
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
//    var debutDetailId : Int
//    var debutDifficulty : Int
    var eventType : Int
    var id : Int
    var lyricist : String
//    var masterDetailId : Int
//    var masterDifficulty : Int
//    var masterPlusDetailId : Int
//    var masterPlusDifficulty : Int
    var musicDataId : Int
    var name : String
    var positionNum : Int
//    var proDetailId : Int
//    var proDifficulty : Int
//    var regularDetailId : Int
//    var regularDifficulty : Int
    var startDate : String
    var type : Int
    
    var liveDetails = [CGSSLiveDetail]()

    lazy var beatmapCount: Int = {
        let semaphore = DispatchSemaphore.init(value: 0)
        var result = 0
        
        let path = String.init(format: DataPath.beatmap, self.id)
        let fm = FileManager.default
        let dbQueue = MusicScoreDBQueue.init(path: path)
        if fm.fileExists(atPath: path) {
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
    
    lazy var beatmaps: [CGSSBeatmap] = {
        guard let beatmaps = CGSSGameResource.shared.getBeatmaps(liveId: self.id) else {
            return [CGSSBeatmap]()
        }
        return beatmaps
    }()

    lazy var legacyMasterPlusBeatmap: CGSSBeatmap? = {
        guard let beatmap = CGSSGameResource.shared.getLegacyBeatmap(liveId: self.id) else {
            return nil
        }
        return beatmap
    }()
    
    /// used in filter
    var difficultyTypes: CGSSLiveDifficultyTypes = .all
    
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
        let debutDetailId = json["debut_detail_id"].intValue
        let debutStars = json["debut_difficulty"].intValue
        let debutNotes = json["debut_notes_number"].intValue
        eventType = json["event_type"].intValue
        id = json["id"].intValue
        lyricist = json["lyricist"].stringValue
        let masterDetailId = json["master_detail_id"].intValue
        let masterStars = json["master_difficulty"].intValue
        let masterNotes = json["master_notes_number"].intValue

        let masterPlusDetailId = json["master_plus_detail_id"].intValue
        let masterPlusStars = json["master_plus_difficulty"].intValue
        let masterPlusNotes = json["master_plus_notes_number"].intValue

        musicDataId = json["music_data_id"].intValue
        name = json["name"].stringValue.replacingOccurrences(of: "\\n", with: "")
        positionNum = json["position_num"].intValue
        let proDetailId = json["pro"].intValue
        let proStars = json["pro_difficulty"].intValue
        let proNotes = json["pro_notes_number"].intValue
        let regularDetailId = json["regular_detail_id"].intValue
        let regularStars = json["regular_difficulty"].intValue
        let regularNotes = json["regular_notes_number"].intValue

        startDate = json["start_date"].stringValue
        type = json["type"].intValue
        super.init()
        
        liveDetails.append(CGSSLiveDetail(detailId: debutDetailId, difficulty: .debut, stars: debutStars, numberOfNotes: debutNotes))
        liveDetails.append(CGSSLiveDetail(detailId: regularDetailId, difficulty: .regular, stars: regularStars, numberOfNotes: regularNotes))
        liveDetails.append(CGSSLiveDetail(detailId: proDetailId, difficulty: .pro, stars: proStars, numberOfNotes: proNotes))
        liveDetails.append(CGSSLiveDetail(detailId: masterDetailId, difficulty: .master, stars: masterStars, numberOfNotes: masterNotes))
        liveDetails.append(CGSSLiveDetail(detailId: masterPlusDetailId, difficulty: .masterPlus, stars: masterPlusStars, numberOfNotes: masterPlusNotes))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
