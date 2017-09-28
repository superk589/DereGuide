//
//  CGSSSongFilter.swift
//  DereGuide
//
//  Created by zzk on 11/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation

struct CGSSSongFilter: CGSSFilter {
    
    var liveTypes: CGSSLiveTypes
    var eventTypes: CGSSLiveEventTypes
    var centerTypes: CGSSCardTypes
    var positionNumTypes: CGSSPositionNumberTypes
    var favoriteTypes: CGSSFavoriteTypes
    
    var searchText: String = ""
    
    init(liveMask: UInt, eventMask: UInt, centerMask: UInt, positionNumMask: UInt, favoriteMask: UInt) {
        liveTypes = CGSSLiveTypes.init(rawValue: liveMask)
        eventTypes = CGSSLiveEventTypes.init(rawValue: eventMask)
        centerTypes = CGSSCardTypes.init(rawValue: centerMask)
        positionNumTypes = CGSSPositionNumberTypes.init(rawValue: positionNumMask)
        favoriteTypes = CGSSFavoriteTypes.init(rawValue: favoriteMask)
    }
    
    func filter(_ list: [CGSSSong]) -> [CGSSSong] {
        // let date1 = Date()
        let result = list.filter { (v: CGSSSong) -> Bool in
            let r1: Bool = searchText == "" ? true : {
                let comps = searchText.components(separatedBy: " ")
                for comp in comps {
                    if comp == "" { continue }
                    let b1 = { v.name.lowercased().contains(comp.lowercased()) }
                    let b2 = { v.detail.lowercased().contains(comp.lowercased())}
                    if b1() || b2() {
                        continue
                    } else {
                        return false
                    }
                }
                return true
                }()
            
            let r2: Bool = {
                var b1 = false
                if liveTypes == .all {
                    b1 = true
                } else {
                    if liveTypes.contains(v.filterType) {
                        b1 = true
                    }
                }
                
                var b2 = false
                if eventTypes == .all {
                    b2 = true
                } else {
                    if eventTypes.contains(v.eventFilterType) {
                        b2 = true
                    }
                }
                
                var b3 = false
                if centerTypes == .all {
                    b3 = true
                } else {
                    if centerTypes.contains(v.centerType) {
                        b3 = true
                    }
                }
                
                var b4 = false
                if positionNumTypes == .all {
                    b4 = true
                } else {
                    if positionNumTypes.contains(v.positionNumType) {
                        b4 = true
                    }
                }
                
                var b7 = false
                if favoriteTypes == .all {
                    b7 = true
                } else {
                    if favoriteTypes.contains(v.favoriteType) {
                        b7 = true
                    }
                }
                
                if b1 && b2 && b3 && b4 && b7 {
                    return true
                }
                return false
            }()
            
            return r1 && r2
        }

        return result
    }
    
    func toDictionary() -> NSDictionary {
        let dict = ["liveMask": liveTypes.rawValue, "eventMask": eventTypes.rawValue, "centerMask": centerTypes.rawValue, "favoriteMask": favoriteTypes.rawValue, "positionNumMask": positionNumTypes.rawValue] as NSDictionary
        return dict
    }
    
    func save(to path: String) {
        toDictionary().write(toFile: path, atomically: true)
    }
    
    init?(fromFile path: String) {
        if let dict = NSDictionary.init(contentsOfFile: path) {
            if let liveMask = dict.object(forKey: "liveMask") as? UInt, let eventMask = dict.object(forKey: "eventMask") as? UInt, let centerMask = dict.object(forKey: "centerMask") as? UInt, let favoriteMask = dict.object(forKey: "favoriteMask") as? UInt, let positionNumMask = dict.object(forKey: "positionNumMask") as? UInt {
                
                self.init(liveMask: liveMask, eventMask: eventMask, centerMask: centerMask, positionNumMask: positionNumMask, favoriteMask: favoriteMask)
                return
            }
        }
        return nil
    }
}

