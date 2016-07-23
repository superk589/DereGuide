//
//  CGSSSorter.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

public class CGSSSorter {
    var att:String
    var ascending:Bool
    init(att:String, ascending:Bool) {
        self.att = att
        self.ascending = ascending
    }
    convenience init(att:String) {
        self.init(att:att, ascending: false)
    }
    
    func sortList<T:CGSSBaseModel>(inout list:[T]) {
        let compare = { (c1:T, c2:T) -> Bool in
            if let i1 = c1.valueForKeyPath(self.att) as? Int , i2 = c2.valueForKeyPath(self.att) as? Int {
                return self.ascending ? (i1 < i2) : (i1 > i2)
            } else if let s1 = c1.valueForKeyPath(self.att) as? String , s2 = c2.valueForKeyPath(self.att) as? String {
                return self.ascending ? (s1 < s2) : (s1 > s2)
            }
            return false
        }
        list.sortInPlace(compare)
    }
}
