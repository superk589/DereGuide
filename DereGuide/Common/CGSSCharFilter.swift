//
//  CGSSCharFilter.swift
//  DereGuide
//
//  Created by zzk on 16/8/31.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

struct CGSSCharFilter: CGSSFilter {
    
    var charTypes: CGSSCharTypes
    var charAgeTypes: CGSSCharAgeTypes
    var charBloodTypes: CGSSCharBloodTypes
    var charCVTypes: CGSSCharCVTypes
    var favoriteTypes: CGSSFavoriteTypes
    var searchText: String = ""
    init(typeMask: UInt, ageMask: UInt, bloodMask: UInt, cvMask: UInt, favoriteMask: UInt) {
        charTypes = CGSSCharTypes.init(rawValue: typeMask)
        charAgeTypes = CGSSCharAgeTypes.init(rawValue: ageMask)
        charBloodTypes = CGSSCharBloodTypes.init(rawValue: bloodMask)
        charCVTypes = CGSSCharCVTypes.init(rawValue: cvMask)
        favoriteTypes = CGSSFavoriteTypes.init(rawValue: favoriteMask)
    }

    func filter(_ list: [CGSSChar]) -> [CGSSChar] {
        let result = list.filter { (v: CGSSChar) -> Bool in
            
            let r1 = searchText == "" ? true : {
                let comps = searchText.components(separatedBy: " ")
                for comp in comps {
                    if comp == "" { continue }
                    let b1 = v.name?.lowercased().contains(comp.lowercased()) ?? false
                    let b2 = v.conventional?.lowercased().contains(comp.lowercased()) ?? false
                    let b3 = v.voice?.lowercased().contains(comp.lowercased()) ?? false
                    let b4 = v.nameKana?.lowercased().contains(comp.lowercased()) ?? false
                    if b1 || b2 || b3 || b4 {
                        continue
                    } else {
                        return false
                    }
                }
                return true
            }()
            
            let r2: Bool = {
                if charTypes.contains(v.charType) && charAgeTypes.contains(v.charAgeType) && charBloodTypes.contains(v.charBloodType) && charCVTypes.contains(v.charCVType) && favoriteTypes.contains(v.favoriteType) {
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
        let dict = ["typeMask": charTypes.rawValue, "ageMask": charAgeTypes.rawValue, "bloodMask": charBloodTypes.rawValue, "cvMask": charCVTypes.rawValue, "favoriteMask": favoriteTypes.rawValue] as NSDictionary
        return dict
    }
    
    init?(fromFile path: String) {
        if let dict = NSDictionary.init(contentsOfFile: path) {
            if let typeMask = dict.object(forKey: "typeMask") as? UInt, let ageMask = dict.object(forKey: "ageMask") as? UInt, let bloodMask = dict.object(forKey: "bloodMask") as? UInt, let cvMask = dict.object(forKey: "cvMask") as? UInt, let favoriteMask = dict.object(forKey: "favoriteMask") as? UInt {
                self.init(typeMask: typeMask, ageMask: ageMask, bloodMask: bloodMask, cvMask: cvMask, favoriteMask: favoriteMask)
                return
            }
        }
        return nil
    }
}
