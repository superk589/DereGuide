//
//  DMCleared.swift
//  DereGuide
//
//  Created by zzk on 31/08/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON


class DMCleared : Codable{
    
    var debut : Int!
    var master : Int!
    var masterPlus : Int!
    var normal : Int!
    var pro : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        debut = json["debut"].intValue
        master = json["master"].intValue
        masterPlus = json["master_plus"].intValue
        normal = json["normal"].intValue
        pro = json["pro"].intValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if debut != nil{
            dictionary["debut"] = debut
        }
        if master != nil{
            dictionary["master"] = master
        }
        if masterPlus != nil{
            dictionary["master_plus"] = masterPlus
        }
        if normal != nil{
            dictionary["normal"] = normal
        }
        if pro != nil{
            dictionary["pro"] = pro
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        debut = aDecoder.decodeObject(forKey: "debut") as? Int
        master = aDecoder.decodeObject(forKey: "master") as? Int
        masterPlus = aDecoder.decodeObject(forKey: "master_plus") as? Int
        normal = aDecoder.decodeObject(forKey: "normal") as? Int
        pro = aDecoder.decodeObject(forKey: "pro") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if debut != nil{
            aCoder.encode(debut, forKey: "debut")
        }
        if master != nil{
            aCoder.encode(master, forKey: "master")
        }
        if masterPlus != nil{
            aCoder.encode(masterPlus, forKey: "master_plus")
        }
        if normal != nil{
            aCoder.encode(normal, forKey: "normal")
        }
        if pro != nil{
            aCoder.encode(pro, forKey: "pro")
        }
        
    }
    
}
