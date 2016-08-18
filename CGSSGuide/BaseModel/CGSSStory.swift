//
//  CGSSStory.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/18.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON
class CGSSStory: CGSSBaseModel {
    
    var cleaned: String!
    var id: Int!
    var subtitle: String!
    var title: String!
    
    /**
         * Instantiate the instance using the passed json values to set the properties values
         */
    init(fromJson json: JSON!) {
        super.init()
        if json == nil {
            return
        }
        cleaned = json["cleaned"].stringValue
        id = json["id"].intValue
        subtitle = json["subtitle"].stringValue
        title = json["title"].stringValue
    }
    
    /**
         * NSCoding required initializer.
         * Fills the data from the passed decoder
         */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cleaned = aDecoder.decodeObjectForKey("cleaned") as? String
        id = aDecoder.decodeObjectForKey("id") as? Int
        subtitle = aDecoder.decodeObjectForKey("subtitle") as? String
        title = aDecoder.decodeObjectForKey("title") as? String
        
    }
    
    /**
         * NSCoding required method.
         * Encodes mode properties into the decoder
         */
    override func encodeWithCoder(aCoder: NSCoder)
    {
        super.encodeWithCoder(aCoder)
        if cleaned != nil {
            aCoder.encodeObject(cleaned, forKey: "cleaned")
        }
        if id != nil {
            aCoder.encodeObject(id, forKey: "id")
        }
        if subtitle != nil {
            aCoder.encodeObject(subtitle, forKey: "subtitle")
        }
        if title != nil {
            aCoder.encodeObject(title, forKey: "title")
        }
        
    }
    
}
