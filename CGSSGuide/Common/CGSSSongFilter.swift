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
    case normal = 1
    case tradition = 2
    case groove = 4
    init (eventType: Int) {
        switch eventType {
        case 0:
            self = .normal
        case 1:
            self = .tradition
        case 3:
            self = .groove
        default:
            self = .normal
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
    
    func addSongFilterType(_ filterType: CGSSSongFilterType) {
        self.songFilterTypes.append(filterType)
    }
    func addEventFilterType(_ filterType: CGSSSongEventFilterType) {
        eventFilterTypes.append(filterType)
    }
    
    func removeSongFilterType(_ filterType: CGSSSongFilterType) {
        if let index = self.songFilterTypes.index(of: filterType) {
            self.songFilterTypes.remove(at: index)
        }
    }
    func removeEventFilterType(_ filterType: CGSSSongEventFilterType) {
        if let index = self.eventFilterTypes.index(of: filterType) {
            self.eventFilterTypes.remove(at: index)
        }
    }
    
    func hasSongFilterType(_ filterType: CGSSSongFilterType) -> Bool {
        return self.songFilterTypes.contains(filterType)
    }
    func hasEventFilterType(_ filterType: CGSSSongEventFilterType) -> Bool {
        return self.eventFilterTypes.contains(filterType)
    }
    
    func filterSongList(_ liveList: [CGSSLive]) -> [CGSSLive] {
        let result = liveList.filter { (v: CGSSLive) -> Bool in
            if songFilterTypes.contains(v.songType) && eventFilterTypes.contains(v.eventFilterType) {
                return true
            }
            return false
        }
        return result
    }
    
    func writeToFile(_ path: String) {
        var typeMask: UInt = 0
        for type in songFilterTypes {
            typeMask += type.rawValue
        }
        var eventMask: UInt = 0
        for type in eventFilterTypes {
            eventMask += type.rawValue
        }
        
        let dict = ["typeMask": typeMask, "eventMask": eventMask] as NSDictionary
        dict.write(toFile: path, atomically: true)
    }
    
    static func readFromFile(_ path: String) -> CGSSSongFilter? {
        if let dict = NSDictionary.init(contentsOfFile: path) {
            if let typeMask = dict.object(forKey: "typeMask") as? UInt, let eventMask = dict.object(forKey: "eventMask") as? UInt {
                return CGSSSongFilter.init(typeMask: typeMask, eventMask: eventMask)
            }
        }
        return nil
    }
    
}
