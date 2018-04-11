//
//  EventTrend.swift
//  DereGuide
//
//  Created by zzk on 2017/4/2.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON


extension EventTrend {
    var date: Date {
        return startDate.toDate()
    }
    
    var dateString: String {
        return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
    }
    
}

class EventTrend : NSObject, NSCoding {
    
    var endDate : String!
    var eventId : Int!
    var id : Int!
    var liveDataIds : [Int]!
    var startDate : String!
    
    lazy var lives: [CGSSLive] = {
        return self.liveDataIds.compactMap {
            var result: CGSSLive?
            let semaphore = DispatchSemaphore.init(value: 0)
            CGSSGameResource.shared.master.getLives(liveId: $0, callback: { (lives) in
                result = lives.first
                semaphore.signal()
            })
            semaphore.wait()
            return result
        }
    }()
//    lazy var lives: [CGSSLive] = {
//        self.liveDataIds.
//        var results = [CGSSLive]()
//        let group = DispatchGroup.init()
//        for liveId in self.liveDataIds {
//            group.enter()
//            CGSSGameResource.shared.master.getLives(liveId: liveId, callback: { (lives) in
//                results.append(contentsOf: lives)
//                group.leave()
//            })
//        }
//        
//        group.wait()
//        return results
//    }()

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        endDate = json["end_date"].stringValue
        eventId = json["event_id"].intValue
        id = json["id"].intValue
        
        self.liveDataIds = [Int]()
        var i = 1
        while json["live_data_id_\(i)"] != JSON.null {
            self.liveDataIds.append(json["live_data_id_\(i)"].intValue)
            i += 1
        }
        startDate = json["start_date"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        if endDate != nil {
            dictionary["end_date"] = endDate
        }
        if eventId != nil {
            dictionary["event_id"] = eventId
        }
        if id != nil {
            dictionary["id"] = id
        }
        if liveDataIds != nil {
            dictionary["live_data_ids"] = liveDataIds
        }
        if startDate != nil {
            dictionary["start_date"] = startDate
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    required init(coder aDecoder: NSCoder) {
        endDate = aDecoder.decodeObject(forKey: "end_date") as? String
        eventId = aDecoder.decodeObject(forKey: "event_id") as? Int
        id = aDecoder.decodeObject(forKey: "id") as? Int
        liveDataIds = aDecoder.decodeObject(forKey: "live_data_ids") as? [Int]
        startDate = aDecoder.decodeObject(forKey: "start_date") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder) {
        if endDate != nil{
            aCoder.encode(endDate, forKey: "end_date")
        }
        if eventId != nil{
            aCoder.encode(eventId, forKey: "event_id")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if liveDataIds != nil{
            aCoder.encode(liveDataIds, forKey: "live_data_ids")
        }
        if startDate != nil{
            aCoder.encode(startDate, forKey: "start_date")
        }
        
    }
    
}
