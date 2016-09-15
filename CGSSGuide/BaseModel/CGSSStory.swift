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
        cleaned = aDecoder.decodeObject(forKey: "cleaned") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        subtitle = aDecoder.decodeObject(forKey: "subtitle") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        
    }
    
    /**
         * NSCoding required method.
         * Encodes mode properties into the decoder
         */
    override func encode(with aCoder: NSCoder)
    {
        super.encode(with: aCoder)
        if cleaned != nil {
            aCoder.encode(cleaned, forKey: "cleaned")
        }
        if id != nil {
            aCoder.encode(id, forKey: "id")
        }
        if subtitle != nil {
            aCoder.encode(subtitle, forKey: "subtitle")
        }
        if title != nil {
            aCoder.encode(title, forKey: "title")
        }
        
    }
    
}
