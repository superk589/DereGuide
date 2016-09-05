//
//  CGSSSongFilter.swift
//  CGSSGuide
//
//  Created by zzk on 16/9/5.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

typealias CGSSSongFilterType = CGSSCardFilterType
enum CGSSSongEventFilterType: UInt {
    case Normal = 1
    case Tradition = 2
    case Groove = 4
    init (eventType: Int) {
        switch eventType {
        case 0:
            self = .Normal
        case 1:
            self = .Tradition
        case 3:
            self = .Groove
        default:
            self = .Normal
        }
    }
    init? (raw: Int) {
        self.init(rawValue: UInt(raw))
    }
}
class CGSSSongFilter {
    var songFilterTypes = [CGSSSongFilterType]()
    var eventFilterTypes = [CGSSSongEventFilterType]()
    
    init(typeMask: UInt, eventMask: UInt) {
        for i: UInt in 0...3 {
            let mask = typeMask >> i
            if mask % 2 == 1 {
                songFilterTypes.append(CGSSSongFilterType.init(raw: 1 << i)!)
            }
        }
        
        for i: UInt in 0...2 {
            let mask = eventMask >> i
            if mask % 2 == 1 {
                eventFilterTypes.append(CGSSSongEventFilterType.init(rawValue: 1 << i)!)
            }
        }
        
    }
    
    func addSongFilterType(filterType: CGSSSongFilterType) {
        self.songFilterTypes.append(filterType)
    }
    func addEventFilterType(filterType: CGSSSongEventFilterType) {
        eventFilterTypes.append(filterType)
    }
    
    func removeSongFilterType(filterType: CGSSSongFilterType) {
        if let index = self.songFilterTypes.indexOf(filterType) {
            self.songFilterTypes.removeAtIndex(index)
        }
    }
    func removeEventFilterType(filterType: CGSSSongEventFilterType) {
        if let index = self.eventFilterTypes.indexOf(filterType) {
            self.eventFilterTypes.removeAtIndex(index)
        }
    }
    
    func hasSongFilterType(filterType: CGSSSongFilterType) -> Bool {
        return self.songFilterTypes.contains(filterType)
    }
    func hasEventFilterType(filterType: CGSSSongEventFilterType) -> Bool {
        return self.eventFilterTypes.contains(filterType)
    }
    
    func filterSongList(liveList: [CGSSLive]) -> [CGSSLive] {
        let result = liveList.filter { (v: CGSSLive) -> Bool in
            if songFilterTypes.contains(v.songType) && eventFilterTypes.contains(v.eventFilterType) {
                return true
            }
            return false
        }
        return result
    }
    
    func writeToFile(path: String) {
        var typeMask: UInt = 0
        for type in songFilterTypes {
            typeMask += type.rawValue
        }
        var eventMask: UInt = 0
        for type in eventFilterTypes {
            eventMask += type.rawValue
        }
        
        let dict = ["typeMask": typeMask, "eventMask": eventMask] as NSDictionary
        dict.writeToFile(path, atomically: true)
    }
    
    static func readFromFile(path: String) -> CGSSSongFilter? {
        if let dict = NSDictionary.init(contentsOfFile: path) {
            if let typeMask = dict.objectForKey("typeMask") as? UInt, eventMask = dict.objectForKey("eventMask") as? UInt {
                return CGSSSongFilter.init(typeMask: typeMask, eventMask: eventMask)
            }
        }
        return nil
    }
    
}
