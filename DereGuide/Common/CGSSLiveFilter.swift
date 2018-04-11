//
//  CGSSLiveFilter.swift
//  DereGuide
//
//  Created by zzk on 16/9/5.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

struct CGSSLiveFilter: CGSSFilter {
    var liveTypes: CGSSLiveTypes
    var eventTypes: CGSSLiveEventTypes
    var difficultyTypes: CGSSLiveDifficultyTypes
    
    var searchText: String = ""
    
    init(typeMask: UInt, eventMask: UInt, difficultyMask: UInt) {
        liveTypes = CGSSLiveTypes.init(rawValue: typeMask)
        eventTypes = CGSSLiveEventTypes.init(rawValue: eventMask)
        difficultyTypes = CGSSLiveDifficultyTypes.init(rawValue: difficultyMask)
    }
    
    func filter(_ list: [CGSSLive]) -> [CGSSLive] {
        let result = list.filter { (v: CGSSLive) -> Bool in
            let r1: Bool = searchText == "" ? true : {
                let comps = searchText.components(separatedBy: " ")
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
                if liveTypes.contains(v.filterType) && eventTypes.contains(v.eventFilterType) {
                    v.difficultyTypes = difficultyTypes
                    if difficultyTypes == .masterPlus {
                        if v.beatmapCount == 4 {
                            return false
                        }
                    }
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
        let dict = ["typeMask": liveTypes.rawValue, "eventMask": eventTypes.rawValue, "difficultyMask": difficultyTypes.rawValue] as NSDictionary
        return dict
    }
    
    init?(fromFile path: String) {
        guard let dict = NSDictionary.init(contentsOfFile: path) else {
            return nil
        }
        guard let typeMask = dict.object(forKey: "typeMask") as? UInt, let eventMask = dict.object(forKey: "eventMask") as? UInt, let difficultyMask = dict.object(forKey: "difficultyMask") as? UInt else {
            return nil
        }
        self.init(typeMask: typeMask, eventMask: eventMask, difficultyMask: difficultyMask)
    }
}
