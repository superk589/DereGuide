//
//  EventPtDataRequest.swift
//  DereGuide
//
//  Created by zzk on 2017/1/25.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventPtDataRequest {

    static func requestPtData(event: CGSSEvent, callback: ((EventRanking?) -> Void)?) {
        BaseRequest.default.getWith(urlString: "https://portal.starlightstage.jp/api/v2/event/\(event.id)/point_ranking.json") { (data, response, error) in
            if error == nil && response?.statusCode == 200 {
                let json = JSON(data!)
                let list = EventRanking.init(fromJson: json["data"])
                list.event = event
                callback?(list)
            } else {
                callback?(nil)
            }
        }
    }
    
    static func requestHighScoreData(event: CGSSEvent, callback: ((EventRanking?) -> Void)?) {
        BaseRequest.default.getWith(urlString: "https://portal.starlightstage.jp/api/v2/event/\(event.id)/highscore_ranking.json") { (data, response, error) in
            if error == nil && response?.statusCode == 200 {
                let json = JSON(data!)
                let list = EventRanking.init(fromJson: json["data"])
                list.event = event
                callback?(list)
            } else {
                callback?(nil)
            }
        }
    }
}
