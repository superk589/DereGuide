//
//  CGSSCardSorter.swift
//  CGSSFoundation
//
//  Created by zzk on 16/7/2.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation


public class CGSSCardSorter {
    
    public var att:String
    public var ascending:Bool
    public init(att:String, ascending:Bool) {
        self.att = att
        self.ascending = ascending
    }
    public convenience init(att:String) {
        self.init(att:att, ascending: false)
    }
    
    func sortCardList(inout cardList:[CGSSCard]) {
        
        let compare = { (c1:CGSSCard, c2:CGSSCard) -> Bool in
            if let i1 = c1.valueForKey(self.att) as? Int , i2 = c2.valueForKey(self.att) as? Int{
                return self.ascending ? (i1 < i2) : (i1 > i2)
            } else if let s1 = c1.valueForKey(self.att) as? String , s2 = c2.valueForKey(self.att) as? String {
                return self.ascending ? (s1 < s2) : (s1 > s2)
            }
            return false
        }
        cardList.sortInPlace(compare)
    }
    
}