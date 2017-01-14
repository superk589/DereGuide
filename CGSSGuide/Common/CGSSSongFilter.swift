//
//  CGSSSongFilter.swift
//  CGSSGuide
//
//  Created by zzk on 16/9/5.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

struct CGSSSongFilter: CGSSFilter {
    var songTypes: CGSSSongTypes
    var eventTypes: CGSSSongEventTypes
    
    init(typeMask: UInt, eventMask: UInt) {
        songTypes = CGSSSongTypes.init(rawValue: typeMask)
        eventTypes = CGSSSongEventTypes.init(rawValue: eventMask)
    }
    
    func filterSongList(_ liveList: [CGSSLive]) -> [CGSSLive] {
        let result = liveList.filter { (v: CGSSLive) -> Bool in
            if songTypes.contains(v.songType) && eventTypes.contains(v.eventFilterType) {
                return true
            }
            return false
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
            }
        }
        return nil
    }
}
