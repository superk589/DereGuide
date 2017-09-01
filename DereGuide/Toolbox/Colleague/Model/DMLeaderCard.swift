//
//  DMLeaderCard.swift
//  DereGuide
//
//  Created by zzk on 31/08/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

class DMLeaderCard : NSObject, NSCoding{
    
    var exp : Int!
    var id : Int!
    var level : Int!
    var love : Int!
    var potential : DMPotential!
    var skillLevel : Int!
    var starRank : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        exp = json["exp"].intValue
        id = json["id"].intValue
        level = json["level"].intValue
        love = json["love"].intValue
        let potentialJson = json["potential"]
        if !potentialJson.isEmpty{
            potential = DMPotential(fromJson: potentialJson)
        }
        skillLevel = json["skill_level"].intValue
        starRank = json["star_rank"].intValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if exp != nil{
            dictionary["exp"] = exp
        }
        if id != nil{
            dictionary["id"] = id
        }
        if level != nil{
            dictionary["level"] = level
        }
        if love != nil{
            dictionary["love"] = love
        }
        if potential != nil{
            dictionary["potential"] = potential.toDictionary()
        }
        if skillLevel != nil{
            dictionary["skill_level"] = skillLevel
        }
        if starRank != nil{
            dictionary["star_rank"] = starRank
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        exp = aDecoder.decodeObject(forKey: "exp") as? Int
        id = aDecoder.decodeObject(forKey: "id") as? Int
        level = aDecoder.decodeObject(forKey: "level") as? Int
        love = aDecoder.decodeObject(forKey: "love") as? Int
        potential = aDecoder.decodeObject(forKey: "potential") as? DMPotential
        skillLevel = aDecoder.decodeObject(forKey: "skill_level") as? Int
        starRank = aDecoder.decodeObject(forKey: "star_rank") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if exp != nil{
            aCoder.encode(exp, forKey: "exp")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if level != nil{
            aCoder.encode(level, forKey: "level")
        }
        if love != nil{
            aCoder.encode(love, forKey: "love")
        }
        if potential != nil{
            aCoder.encode(potential, forKey: "potential")
        }
        if skillLevel != nil{
            aCoder.encode(skillLevel, forKey: "skill_level")
        }
        if starRank != nil{
            aCoder.encode(starRank, forKey: "star_rank")
        }
        
    }
    
}
