//
//  CGSSSorter.swift
//  DereGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

struct CGSSSorter {
    
    var property: String
    var ascending: Bool
    var displayName: String = ""
    
    init(property: String, ascending: Bool) {
        self.property = property
        self.ascending = ascending
    }
    
    init(property: String) {
        self.init(property: property, ascending: false)
    }
    
    func sortList<T: CGSSBaseModel>(_ list: inout [T]) {
        let compare = { (c1: T, c2: T) -> Bool in
            if let i1 = c1.value(forKeyPath: self.property) as? Int, let i2 = c2.value(forKeyPath: self.property) as? Int {
                return self.ascending ? (i1 < i2) : (i1 > i2)
            } else if let s1 = c1.value(forKeyPath: self.property) as? String, let s2 = c2.value(forKeyPath: self.property) as? String {
                return self.ascending ? (s1 < s2) : (s1 > s2)
            }
            return false
        }
        list.sort(by: compare)
    }
    
    func save(to path: String) {
        toDictionary().write(toFile: path, atomically: true)
    }
    
    func toDictionary() -> NSDictionary {
        let dict = ["property": property, "ascending": ascending, "displayName": displayName] as NSDictionary
        return dict
    }
    
    init?(fromFile path: String) {
        if let dict = NSDictionary.init(contentsOfFile: path) {
            if let property = dict.object(forKey: "property") as? String, let ascending = dict.object(forKey: "ascending") as? Bool,
                let displayName = dict.object(forKey: "displayName") as? String {
                self.init(property: property, ascending: ascending)
                self.displayName = displayName
                return
            }
        }
        return nil
    }
}
