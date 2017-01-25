//
//  EventPtDataRequest.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/25.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventPtDataRequest {

    static func requestPtData(event: CGSSEvent, callback: ((EventPtRankingList?) -> Void)?) {
        BaseRequest.default.getWith(urlString: "https://api.tachibana.cool/v1/starlight/event/\(event.id)/ranking_list.json") { (data, response, error) in
            if error == nil {
                let json = JSON.init(data: data!)
                let list = EventPtRankingList.init(fromJson: json)
                callback?(list)
            } else {
                callback?(nil)
            }
        }
    }
    
    static func requestHighScoreData(event: CGSSEvent, callback: ((EventScoreRankingList?) -> Void)?) {
        BaseRequest.default.getWith(urlString: "https://api.tachibana.cool/v1/starlight/event/\(event.id)/ranking_list_high.json") { (data, response, error) in
            if error == nil {
                let json = JSON.init(data: data!)
                let list = EventScoreRankingList.init(fromJson: json)
                callback?(list)
            } else {
                callback?(nil)
            }
        }
    }
}
