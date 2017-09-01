//
//  DMPotential.swift
//  DereGuide
//
//  Created by zzk on 31/08/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

class DMPotential : NSObject, NSCoding{
    
    var dance : Int!
    var life : Int!
    var visual : Int!
    var vocal : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        dance = json["dance"].intValue
        life = json["life"].intValue
        visual = json["visual"].intValue
        vocal = json["vocal"].intValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if dance != nil{
            dictionary["dance"] = dance
        }
        if life != nil{
            dictionary["life"] = life
        }
        if visual != nil{
            dictionary["visual"] = visual
        }
        if vocal != nil{
            dictionary["vocal"] = vocal
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        dance = aDecoder.decodeObject(forKey: "dance") as? Int
        life = aDecoder.decodeObject(forKey: "life") as? Int
        visual = aDecoder.decodeObject(forKey: "visual") as? Int
        vocal = aDecoder.decodeObject(forKey: "vocal") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if dance != nil{
            aCoder.encode(dance, forKey: "dance")
        }
        if life != nil{
            aCoder.encode(life, forKey: "life")
        }
        if visual != nil{
            aCoder.encode(visual, forKey: "visual")
        }
        if vocal != nil{
            aCoder.encode(vocal, forKey: "vocal")
        }
        
    }
    
}
