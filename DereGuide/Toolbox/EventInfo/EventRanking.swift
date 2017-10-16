//
//  EventRanking.swift
//  DereGuide
//
//  Created by zzk on 2017/1/24.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

extension EventRanking {
    
    var lastDate: Date? {
        if let date = list.last?.date.toDate(format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ") {
            return date
        } else {
            return nil
        }
    }
    var last: EventLogItem? {
        return list.last
    }
    
    var speed: EventRankingSpeed {
        var subList = [EventLogItem]()
        var count = 0
        for i in 0..<list.count {
            let ranking = list[list.count - i - 1]
            count += 1
            subList.append(ranking)
            if count >= 2 {
                break
            }
        }
        
        var speeds = [Int: Int]()
        if let first = subList.first, let last = subList.last {
            let timeInterval = last.date.toDate(format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ").timeIntervalSince(first.date.toDate(format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ"))
            let hourInterval = timeInterval / 3600
            if hourInterval != 0 {
                for border in [1, 2, 3] + borders {
                    speeds[border] = Int(round(Double(last[border] - first[border]) / hourInterval))
                }
            }
        }
    
        return EventRankingSpeed.init(speeds)
    }
}

class EventRanking {
    
    var list: [EventLogItem]
    var borders: [Int]
    // not from json
    var event: CGSSEvent!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON){
        list = [EventLogItem]()
        borders = [Int]()
        for sub in json["borders"].arrayValue {
            borders.append(sub.intValue)
        }
        
        for sub in json["log"].dictionaryValue {
            if let item = EventLogItem.init(fromJson: sub.value, borders: borders) {
                list.append(item)
            }
        }
        list.sort { $0.date < $1.date }
    }
    
}
