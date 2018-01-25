//
//  CGSSEventFilter.swift
//  DereGuide
//
//  Created by zzk on 2017/1/14.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

struct CGSSEventFilter: CGSSFilter {

    var eventTypes: CGSSEventTypes
    
    var searchText: String = ""
    
    init(typeMask: UInt) {
        eventTypes = CGSSEventTypes.init(rawValue: typeMask)
    }
    
    func filter(_ list: [CGSSEvent]) -> [CGSSEvent] {
        let result = list.filter { (v: CGSSEvent) -> Bool in
            let r1: Bool = searchText == "" ? true : {
                let comps = searchText.components(separatedBy: "")
                for comp in comps {
                    if comp == "" { continue }
                    let b1 = v.name.lowercased().contains(comp.lowercased())
                    if b1 {
                        continue
                    } else {
                        return false
                    }
                }
                return true
            }()
            let r2: Bool = {
                if eventTypes.contains(v.eventType) {
                    return true
                }
                return false
            }()
            return r1 && r2
        }
        return result

    }
 
    
    func save(to path: String) {
        toDictionary().write(toFile: path, atomically: true)
    }
    
    func toDictionary() -> NSDictionary {
        let dict = ["typeMask": eventTypes.rawValue] as NSDictionary
        return dict
    }
    
    init?(fromFile path: String) {
        if let dict = NSDictionary.init(contentsOfFile: path) {
            if let typeMask = dict.object(forKey: "typeMask") as? UInt {
                self.init(typeMask: typeMask)
                return
            }
        }
        return nil
    }

    
}
