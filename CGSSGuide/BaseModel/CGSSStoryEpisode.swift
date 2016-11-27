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
        if json == JSON.null {
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
        cleaned = aDecoder.decodeObject(forKey: "cleaned") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        story = aDecoder.decodeObject(forKey: "story") as? [CGSSStory]
        subtitle = aDecoder.decodeObject(forKey: "subtitle") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        type = aDecoder.decodeObject(forKey: "type") as? Int
        
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
        if story != nil {
            aCoder.encode(story, forKey: "story")
        }
        if subtitle != nil {
            aCoder.encode(subtitle, forKey: "subtitle")
        }
        if title != nil {
            aCoder.encode(title, forKey: "title")
        }
        if type != nil {
            aCoder.encode(type, forKey: "type")
        }
        
    }
    
}
