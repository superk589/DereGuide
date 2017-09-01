//
//  DMSupportCard.swift
//  DereGuide
//
//  Created by zzk on 31/08/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

class DMSupportCard : NSObject, NSCoding{
    
    var all : DMLeaderCard!
    var cool : DMLeaderCard!
    var cute : DMLeaderCard!
    var passion : DMLeaderCard!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let allJson = json["all"]
        if !allJson.isEmpty{
            all = DMLeaderCard(fromJson: allJson)
        }
        let coolJson = json["cool"]
        if !coolJson.isEmpty{
            cool = DMLeaderCard(fromJson: coolJson)
        }
        let cuteJson = json["cute"]
        if !cuteJson.isEmpty{
            cute = DMLeaderCard(fromJson: cuteJson)
        }
        let passionJson = json["passion"]
        if !passionJson.isEmpty{
            passion = DMLeaderCard(fromJson: passionJson)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if all != nil{
            dictionary["all"] = all.toDictionary()
        }
        if cool != nil{
            dictionary["cool"] = cool.toDictionary()
        }
        if cute != nil{
            dictionary["cute"] = cute.toDictionary()
        }
        if passion != nil{
            dictionary["passion"] = passion.toDictionary()
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        all = aDecoder.decodeObject(forKey: "all") as? DMLeaderCard
        cool = aDecoder.decodeObject(forKey: "cool") as? DMLeaderCard
        cute = aDecoder.decodeObject(forKey: "cute") as? DMLeaderCard
        passion = aDecoder.decodeObject(forKey: "passion") as? DMLeaderCard
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if all != nil{
            aCoder.encode(all, forKey: "all")
        }
        if cool != nil{
            aCoder.encode(cool, forKey: "cool")
        }
        if cute != nil{
            aCoder.encode(cute, forKey: "cute")
        }
        if passion != nil{
            aCoder.encode(passion, forKey: "passion")
        }
        
    }
    
}
