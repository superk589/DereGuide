//
//  CGSSLearderSkill.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

class CGSSLeaderSkill: CGSSBaseModel {
    
    var explain: String!
    var explainEn: String!
    var id: Int!
    var name: String!
    var needCool: Int!
    var needCute: Int!
    var needPassion: Int!
    var specialId: Int!
    var targetAttribute: String!
    var targetParam: String!
    var type: Int!
    var upType: Int!
    var upValue: Int!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        super.init()
        if json == nil {
            return
        }
        explain = json["explain"].stringValue
        explainEn = json["explain_en"].stringValue
        id = json["id"].intValue
        name = json["name"].stringValue
        needCool = json["need_cool"].intValue
        needCute = json["need_cute"].intValue
        needPassion = json["need_passion"].intValue
        specialId = json["special_id"].intValue
        targetAttribute = json["target_attribute"].stringValue
        targetParam = json["target_param"].stringValue
        type = json["type"].intValue
        upType = json["up_type"].intValue
        upValue = json["up_value"].intValue
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        explain = aDecoder.decodeObjectForKey("explain") as? String
        explainEn = aDecoder.decodeObjectForKey("explain_en") as? String
        id = aDecoder.decodeObjectForKey("id") as? Int
        name = aDecoder.decodeObjectForKey("name") as? String
        needCool = aDecoder.decodeObjectForKey("need_cool") as? Int
        needCute = aDecoder.decodeObjectForKey("need_cute") as? Int
        needPassion = aDecoder.decodeObjectForKey("need_passion") as? Int
        specialId = aDecoder.decodeObjectForKey("special_id") as? Int
        targetAttribute = aDecoder.decodeObjectForKey("target_attribute") as? String
        targetParam = aDecoder.decodeObjectForKey("target_param") as? String
        type = aDecoder.decodeObjectForKey("type") as? Int
        upType = aDecoder.decodeObjectForKey("up_type") as? Int
        upValue = aDecoder.decodeObjectForKey("up_value") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    override func encodeWithCoder(aCoder: NSCoder)
    {
        super.encodeWithCoder(aCoder)
        if explain != nil {
            aCoder.encodeObject(explain, forKey: "explain")
        }
        if explainEn != nil {
            aCoder.encodeObject(explainEn, forKey: "explain_en")
        }
        if id != nil {
            aCoder.encodeObject(id, forKey: "id")
        }
        if name != nil {
            aCoder.encodeObject(name, forKey: "name")
        }
        if needCool != nil {
            aCoder.encodeObject(needCool, forKey: "need_cool")
        }
        if needCute != nil {
            aCoder.encodeObject(needCute, forKey: "need_cute")
        }
        if needPassion != nil {
            aCoder.encodeObject(needPassion, forKey: "need_passion")
        }
        if specialId != nil {
            aCoder.encodeObject(specialId, forKey: "special_id")
        }
        if targetAttribute != nil {
            aCoder.encodeObject(targetAttribute, forKey: "target_attribute")
        }
        if targetParam != nil {
            aCoder.encodeObject(targetParam, forKey: "target_param")
        }
        if type != nil {
            aCoder.encodeObject(type, forKey: "type")
        }
        if upType != nil {
            aCoder.encodeObject(upType, forKey: "up_type")
        }
        if upValue != nil {
            aCoder.encodeObject(upValue, forKey: "up_value")
        }
        
    }
    
}