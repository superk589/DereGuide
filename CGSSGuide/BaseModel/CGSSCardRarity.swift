//
//  CGSSCardRarity.swift
//  CGSSFoundation
//
//  Created by zzk on 16/7/2.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

extension CGSSCardRarity {
    var rarityString: String! {
        if rarity != nil {
            return CGSSGlobal.rarityToStirng[rarity]
        } else {
            return ""
        }
    }
}

class CGSSCardRarity: NSObject, NSCoding {
    
    var addMaxLevel: Int!
    var addParam: Int!
    var baseGiveExp: Int!
    var baseGiveMoney: Int!
    var baseMaxLevel: Int!
    var maxLove: Int!
    var maxStarRank: Int!
    var rarity: Int!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json == nil {
            return
        }
        addMaxLevel = json["add_max_level"].intValue
        addParam = json["add_param"].intValue
        baseGiveExp = json["base_give_exp"].intValue
        baseGiveMoney = json["base_give_money"].intValue
        baseMaxLevel = json["base_max_level"].intValue
        maxLove = json["max_love"].intValue
        maxStarRank = json["max_star_rank"].intValue
        rarity = json["rarity"].intValue
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    required init?(coder aDecoder: NSCoder)
    {
        addMaxLevel = aDecoder.decodeObjectForKey("add_max_level") as? Int
        addParam = aDecoder.decodeObjectForKey("add_param") as? Int
        baseGiveExp = aDecoder.decodeObjectForKey("base_give_exp") as? Int
        baseGiveMoney = aDecoder.decodeObjectForKey("base_give_money") as? Int
        baseMaxLevel = aDecoder.decodeObjectForKey("base_max_level") as? Int
        maxLove = aDecoder.decodeObjectForKey("max_love") as? Int
        maxStarRank = aDecoder.decodeObjectForKey("max_star_rank") as? Int
        rarity = aDecoder.decodeObjectForKey("rarity") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encodeWithCoder(aCoder: NSCoder)
    {
        if addMaxLevel != nil {
            aCoder.encodeObject(addMaxLevel, forKey: "add_max_level")
        }
        if addParam != nil {
            aCoder.encodeObject(addParam, forKey: "add_param")
        }
        if baseGiveExp != nil {
            aCoder.encodeObject(baseGiveExp, forKey: "base_give_exp")
        }
        if baseGiveMoney != nil {
            aCoder.encodeObject(baseGiveMoney, forKey: "base_give_money")
        }
        if baseMaxLevel != nil {
            aCoder.encodeObject(baseMaxLevel, forKey: "base_max_level")
        }
        if maxLove != nil {
            aCoder.encodeObject(maxLove, forKey: "max_love")
        }
        if maxStarRank != nil {
            aCoder.encodeObject(maxStarRank, forKey: "max_star_rank")
        }
        if rarity != nil {
            aCoder.encodeObject(rarity, forKey: "rarity")
        }
        
    }
    
}