//
//  EventLogItem.swift
//  DereGuide
//
//  Created by zzk on 2017/1/24.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

class EventLogItem: NSObject {
    
    var date : String!
    var _storage: [Int: Int]
    
    subscript (border: Int) -> Int {
        return _storage[border] ?? 0
    }
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init?(fromJson json: JSON, borders: [Int]) {
        if json.isEmpty {
            return nil
        }
        _storage = [Int: Int]()
        date = json["date"].stringValue
        for border in [1, 2, 3] {
            _storage[border] = json[String(border)].intValue
        }
        for border in borders {
            _storage[border] = json[String(border)].intValue
        }
        super.init()
        
        // fix remote mismatching
        if borders.contains(40000) && _storage[40000] == 0 {
            _storage[40000] = json["50000"].intValue
        } else if borders.contains(50000) && _storage[50000] == 0 {
            _storage[50000] = json["40000"].intValue
        }
    }
    
}
