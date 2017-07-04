//
//  EventScoreItem.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/24.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON


class EventScoreItem : NSObject, NSCoding {
    
    var date : String!
    var rank1 : Int!
    var rank2 : Int!
    var rank3 : Int!
    var reward1 : Int!
    var reward2 : Int!
    var reward3 : Int!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty{
            return
        }
        date = json["date"].stringValue
        rank1 = json["rank1"].intValue
        rank2 = json["rank2"].intValue
        rank3 = json["rank3"].intValue
        reward1 = json["reward1"].intValue
        reward2 = json["reward2"].intValue
        reward3 = json["reward3"].intValue
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        if date != nil {
            dictionary["date"] = date
        }
        if rank1 != nil {
            dictionary["rank1"] = rank1
        }
        if rank2 != nil {
            dictionary["rank2"] = rank2
        }
        if rank3 != nil {
            dictionary["rank3"] = rank3
        }
        if reward1 != nil {
            dictionary["reward1"] = reward1
        }
        if reward2 != nil {
            dictionary["reward2"] = reward2
        }
        if reward3 != nil {
            dictionary["reward3"] = reward3
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    required init(coder aDecoder: NSCoder) {
        date = aDecoder.decodeObject(forKey: "date") as? String
        rank1 = aDecoder.decodeObject(forKey: "rank1") as? Int
        rank2 = aDecoder.decodeObject(forKey: "rank2") as? Int
        rank3 = aDecoder.decodeObject(forKey: "rank3") as? Int
        reward1 = aDecoder.decodeObject(forKey: "reward1") as? Int
        reward2 = aDecoder.decodeObject(forKey: "reward2") as? Int
        reward3 = aDecoder.decodeObject(forKey: "reward3") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder) {
        if date != nil {
            aCoder.encode(date, forKey: "date")
        }
        if rank1 != nil {
            aCoder.encode(rank1, forKey: "rank1")
        }
        if rank2 != nil {
            aCoder.encode(rank2, forKey: "rank2")
        }
        if rank3 != nil {
            aCoder.encode(rank3, forKey: "rank3")
        }
        if reward1 != nil {
            aCoder.encode(reward1, forKey: "reward1")
        }
        if reward2 != nil {
            aCoder.encode(reward2, forKey: "reward2")
        }
        if reward3 != nil {
            aCoder.encode(reward3, forKey: "reward3")
        }
        
    }
    
}
