//
//  CGSSStoryContent.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/18.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

class CGSSStoryContent: CGSSBaseModel {
    
    var args: [String]!
    var name: String!
    
    /**
         * Instantiate the instance using the passed json values to set the properties values
         */
    init(fromJson json: JSON!) {
        super.init()
        if json == JSON.null {
            return
        }
        args = [String]()
        let argsArray = json["args"].arrayValue
        for argsJson in argsArray {
            args.append(argsJson.stringValue)
        }
        name = json["name"].stringValue
    }
    
    /**
         * NSCoding required initializer.
         * Fills the data from the passed decoder
         */
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        args = aDecoder.decodeObject(forKey: "args") as? [String]
        name = aDecoder.decodeObject(forKey: "name") as? String
        
    }
    
    /**
         * NSCoding required method.
         * Encodes mode properties into the decoder
         */
    override func encode(with aCoder: NSCoder)
    {
        super.encode(with: aCoder)
        if args != nil {
            aCoder.encode(args, forKey: "args")
        }
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
        
    }
    
}
