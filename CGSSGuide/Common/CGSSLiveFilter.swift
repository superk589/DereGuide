//
//  CGSSLiveFilter.swift
//  CGSSGuide
//
//  Created by zzk on 16/9/5.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

struct CGSSLiveFilter: CGSSFilter {
    var songTypes: CGSSLiveTypes
    var eventTypes: CGSSLiveEventTypes
    var searchText: String = ""
    init(typeMask: UInt, eventMask: UInt) {
        songTypes = CGSSLiveTypes.init(rawValue: typeMask)
        eventTypes = CGSSLiveEventTypes.init(rawValue: eventMask)
    }
    
    func filter(_ list: [CGSSLive]) -> [CGSSLive] {
        let result = list.filter { (v: CGSSLive) -> Bool in
            let r1: Bool = searchText == "" ? true : {
                let comps = searchText.components(separatedBy: " ")
                for comp in comps {
                    if comp == "" { continue }
                    let b1 = v.musicTitle.lowercased().contains(comp.lowercased())
                    if b1 {
                        continue
                    } else {
                        return false
                    }
                }
                return true
            }()
            let r2: Bool = {
                if songTypes.contains(v.songType) && eventTypes.contains(v.eventFilterType) {
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
        let dict = ["typeMask": songTypes.rawValue, "eventMask": eventTypes.rawValue] as NSDictionary
        return dict
    }
    
    init?(fromFile path: String) {
        if let dict = NSDictionary.init(contentsOfFile: path) {
            if let typeMask = dict.object(forKey: "typeMask") as? UInt, let eventMask = dict.object(forKey: "eventMask") as? UInt {
                self.init(typeMask: typeMask, eventMask: eventMask)
                return
            }
        }
        return nil
    }
}
