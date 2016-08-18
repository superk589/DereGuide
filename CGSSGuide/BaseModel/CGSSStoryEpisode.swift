//
//  CGSSStoryEpisode.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/18.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

class CGSSStoryEpisode: CGSSBaseModel {
    var cleaned: String!
    var id: Int!
    var story: [CGSSStory]!
    var subtitle: String!
    var title: String!
    var type: Int!
    
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
        story = [CGSSStory]()
        let storyArray = json["story"].arrayValue
        for storyJson in storyArray {
            let value = CGSSStory(fromJson: storyJson)
            story.append(value)
        }
        subtitle = json["subtitle"].stringValue
        title = json["title"].stringValue
        type = json["type"].intValue
    }
    
    
    /**
         * NSCoding required initializer.
         * Fills the data from the passed decoder
         */
     required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        cleaned = aDecoder.decodeObjectForKey("cleaned") as? String
        id = aDecoder.decodeObjectForKey("id") as? Int
        story = aDecoder.decodeObjectForKey("story") as? [CGSSStory]
        subtitle = aDecoder.decodeObjectForKey("subtitle") as? String
        title = aDecoder.decodeObjectForKey("title") as? String
        type = aDecoder.decodeObjectForKey("type") as? Int
        
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
        if story != nil {
            aCoder.encodeObject(story, forKey: "story")
        }
        if subtitle != nil {
            aCoder.encodeObject(subtitle, forKey: "subtitle")
        }
        if title != nil {
            aCoder.encodeObject(title, forKey: "title")
        }
        if type != nil {
            aCoder.encodeObject(type, forKey: "type")
        }
        
    }
    
}