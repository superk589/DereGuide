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
        addMaxLevel = aDecoder.decodeObject(forKey: "add_max_level") as? Int
        addParam = aDecoder.decodeObject(forKey: "add_param") as? Int
        baseGiveExp = aDecoder.decodeObject(forKey: "base_give_exp") as? Int
        baseGiveMoney = aDecoder.decodeObject(forKey: "base_give_money") as? Int
        baseMaxLevel = aDecoder.decodeObject(forKey: "base_max_level") as? Int
        maxLove = aDecoder.decodeObject(forKey: "max_love") as? Int
        maxStarRank = aDecoder.decodeObject(forKey: "max_star_rank") as? Int
        rarity = aDecoder.decodeObject(forKey: "rarity") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if addMaxLevel != nil {
            aCoder.encode(addMaxLevel, forKey: "add_max_level")
        }
        if addParam != nil {
            aCoder.encode(addParam, forKey: "add_param")
        }
        if baseGiveExp != nil {
            aCoder.encode(baseGiveExp, forKey: "base_give_exp")
        }
        if baseGiveMoney != nil {
            aCoder.encode(baseGiveMoney, forKey: "base_give_money")
        }
        if baseMaxLevel != nil {
            aCoder.encode(baseMaxLevel, forKey: "base_max_level")
        }
        if maxLove != nil {
            aCoder.encode(maxLove, forKey: "max_love")
        }
        if maxStarRank != nil {
            aCoder.encode(maxStarRank, forKey: "max_star_rank")
        }
        if rarity != nil {
            aCoder.encode(rarity, forKey: "rarity")
        }
        
    }
    
}
