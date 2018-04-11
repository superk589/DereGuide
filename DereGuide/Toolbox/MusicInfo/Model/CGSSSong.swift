//
//  CGSSSong.swift
//  DereGuide
//
//  Created by zzk on 04/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

class CGSSSong: NSObject {
    
    var musicID: Int
    var name: String
    var type: Int
    var eventType: Int
    @objc dynamic var bpm: Int
    var composer: String
    var lyricist: String
    var nameSort: Int
    @objc dynamic var _startDate: String
    var liveID: Int
    var normalLiveID: Int
    var charaPosition1: Int
    var charaPosition2: Int
    var charaPosition3: Int
    var charaPosition4: Int
    var charaPosition5: Int
    var positionNum: Int
    var detail: String
    
    lazy var centerType: CGSSCardTypes = {
        let chara = CGSSDAO.shared.findCharById(charaPosition1)
        return chara?.charType ?? .office
    }()
    
    lazy var live: CGSSLive? = {
        let semaphore = DispatchSemaphore(value: 0)
        var result: CGSSLive?
        CGSSGameResource.shared.master.getLives(liveId: liveID) { (lives) in
            result = lives.first
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }()
    
    lazy var normalLive: CGSSLive? = {
        let semaphore = DispatchSemaphore(value: 0)
        var result: CGSSLive?
        CGSSGameResource.shared.master.getLives(liveId: normalLiveID) { (lives) in
            result = lives.first
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }()
    
    init?(fromJson json: JSON) {
        if json.isEmpty {
            return nil
        }
        bpm = json["bpm"].intValue
        name = json["name"].stringValue.replacingOccurrences(of: "\\n", with: "\n")
        musicID = json["id"].intValue
        composer = json["composer"].stringValue
        lyricist = json["lyricist"].stringValue
        nameSort = json["name_sort"].intValue
        composer = json["composer"].stringValue
        liveID = json["live_id"].intValue
        normalLiveID = json["normal_live_id"].intValue
        charaPosition1 = json["chara_position_1"].intValue
        charaPosition2 = json["chara_position_2"].intValue
        charaPosition3 = json["chara_position_3"].intValue
        charaPosition4 = json["chara_position_4"].intValue
        charaPosition5 = json["chara_position_5"].intValue
        positionNum = json["position_num"].intValue

        _startDate = json["start_date"].stringValue
        detail = json["discription"].stringValue.replacingOccurrences(of: "\\n", with: "\n")
        
        type = json["type"].intValue
        eventType = json["event_type"].intValue

    }
}


extension CGSSSong {
    
    var startDate: Date {
        return _startDate.toDate()
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
    
    var positionNumType: CGSSPositionNumberTypes {
        if charaPosition1 != 0 && charaPosition2 == 0 {
            return .n1
        } else {
            return CGSSPositionNumberTypes(positionNum: positionNum)
        }
    }
    
    var favoriteType: CGSSFavoriteTypes {
        return FavoriteSongsManager.shared.contains(self.musicID) ? CGSSFavoriteTypes.inFavorite : CGSSFavoriteTypes.notInFavorite
    }
    
    var jacketURL: URL {
        return URL.images.appendingPathComponent("/jacket/\(musicID).png")
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
}

