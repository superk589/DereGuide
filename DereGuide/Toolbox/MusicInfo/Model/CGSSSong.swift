//
//  CGSSSong.swift
//  DereGuide
//
//  Created by zzk on 04/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

class CGSSSong: CGSSBaseModel {
    
    var musicID: Int
    var name: String
    var type: Int
    var eventType: Int
    var bpm: Int
    var composer: String
    var lyricist: String
    var nameSort: Int
    var liveID: Int
    var charaPosition1: Int
    var charaPosition2: Int
    var charaPosition3: Int
    var charaPosition4: Int
    var charaPosition5: Int
    var positionNum: Int
    var detail: String
    
    init?(fromJson json: JSON) {
        if json.isEmpty {
            return nil
        }
        bpm = json["bpm"].intValue
        name = json["name"].stringValue
        musicID = json["id"].intValue
        composer = json["composer"].stringValue
        lyricist = json["lyricist"].stringValue
        nameSort = json["name_sort"].intValue
        composer = json["composer"].stringValue
        liveID = json["live_id"].intValue
        charaPosition1 = json["chara_position_1"].intValue
        charaPosition2 = json["chara_position_2"].intValue
        charaPosition3 = json["chara_position_3"].intValue
        charaPosition4 = json["chara_position_4"].intValue
        charaPosition5 = json["chara_position_5"].intValue
        positionNum = json["position_num"].intValue

        detail = json["discription"].stringValue
        
        type = json["type"].intValue
        eventType = json["event_type"].intValue

        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension CGSSSong {
    
    var filterType: CGSSLiveTypes {
        return CGSSLiveTypes.init(type: type)
    }
    
    var eventFilterType: CGSSEventTypes {
        return CGSSEventTypes.init(eventType: eventType)
    }
    
    var centerType: CGSSCardTypes {
        switch charaPosition1 / 100 {
        case 1:
            return .cute
        case 2:
            return .cool
        case 3:
            return .passion
        default:
            // songs without center return live type
            return filterType
        }
    }
    
    var positionNumType: CGSSPositionNumberTypes {
        return CGSSPositionNumberTypes(positionNum: positionNum)
    }
    
    var favoriteType: CGSSFavoriteTypes {
        return FavoriteSongsManager.shared.contains(self.musicID) ? CGSSFavoriteTypes.inFavorite : CGSSFavoriteTypes.notInFavorite
    }
}

