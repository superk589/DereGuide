//
//  CGSSLive.swift
//  DereGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016 zzk. All rights reserved.
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
            return .parade
        case .vocal:
            return .vocal
        case .dance:
            return .dance
        case .visual:
            return .passion
        case .parade:
            return .parade
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
            return .cute
        case .cool:
            return .cool
        case .passion:
            return .passion
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
        return details.map { $0.id }.max() ?? 0
    }
    
    @objc dynamic var maxDiffStars: Int {
        return selectedLiveDetails.map { $0.stars }.max() ?? 0
    }
    
    @objc dynamic var maxNumberOfNotes: Int {
        return selectedLiveDetails.map {
            if $0.numberOfNotes != 0 {
                return $0.numberOfNotes
            } else {
                return getBeatmap(of: $0.difficulty)?.numberOfNotes ?? 0
            }
        }.max() ?? 0
        // this method takes very long time, because it read each beatmap files
//        return self.getBeatmap(of: selectableMaxDifficulty)?.numberOfNotes ?? 0
    }
    
    @objc dynamic var sLength: Float {
        return getBeatmap(of: .debut)?.totalSeconds ?? 0
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
            return .cute
        case 2:
            return .cool
        case 3:
            return .passion
        default:
            return .darkText
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
    
    func getBeatmap(of difficulty: CGSSLiveDifficulty) -> CGSSBeatmap? {
        return beatmaps.first { $0.difficulty == difficulty }
    }
    
    func getLiveDetail(of difficulty: CGSSLiveDifficulty) -> CGSSLiveDetail? {
        return details.first { $0.difficulty == difficulty }
    }
    
    var jacketURL: URL {
        return URL.images.appendingPathComponent("/jacket/\(musicDataId).png")
    }
    
    var selectedLiveDetails: [CGSSLiveDetail] {
        return details.filter {
            self.difficultyTypes.contains($0.difficultyTypes)
        }
    }
    
//    var title: String {
//        if eventType == 0 {
//            return name
//        } else {
//            return name + "(" + NSLocalizedString("活动", comment: "") + ")"
//        }
//    }
    
    subscript (difficulty: CGSSLiveDifficulty) -> CGSSLiveDetail? {
        get {
            return getLiveDetail(of: difficulty)
        }
    }
    
    func merge(anotherLive live: CGSSLive) {
        eventType = max(live.eventType, eventType)
        startDate = min(live.startDate, startDate)
        musicDataId = max(live.musicDataId, musicDataId)
        
        let eventLive: CGSSLive
        let normalLive: CGSSLive
        if self.eventType > live.eventType {
            eventLive = self
            normalLive = live
        } else {
            eventLive = live
            normalLive = self
        }
        
        if !normalLive.details.contains { $0.difficulty == .masterPlus } {
            var liveDetails = normalLive.details
            if let masterPlus = eventLive.details.first(where: { $0.difficulty == .masterPlus }) {
                liveDetails.append(masterPlus)
                id = eventLive.id
            }
            liveDetails.sort { $0.difficulty.rawValue < $1.difficulty.rawValue }
            self.details = liveDetails
        }
    }
}

class CGSSLive: NSObject {
    
    @objc dynamic var bpm : Int
    var eventType : Int
    var id : Int
    var musicDataId : Int
    var name : String
    @objc dynamic var startDate : String
    var type : Int
    
    var details = [CGSSLiveDetail]()

    lazy var beatmapCount: Int = {
        let semaphore = DispatchSemaphore.init(value: 0)
        var result = 0
        
        let path = String.init(format: DataPath.beatmap, self.id)
        let fm = FileManager.default
        if fm.fileExists(atPath: path) {
            let dbQueue = MusicScoreDBQueue.init(path: path)
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
        return CGSSGameResource.shared.getBeatmaps(liveId: self.id) ?? []
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
        eventType = json["event_type"].intValue
        id = json["id"].intValue
        musicDataId = json["music_data_id"].intValue
        name = json["name"].stringValue.replacingOccurrences(of: "\\n", with: "")
        startDate = json["start_date"].stringValue
        type = json["type"].intValue
        super.init()
    }
    
}
