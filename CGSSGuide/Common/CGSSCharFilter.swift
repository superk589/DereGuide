//
//  CGSSCharFilter.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/31.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

struct CGSSCharFilter {
    
    var charTypes: CGSSCharTypes
    var charAgeTypes: CGSSCharAgeTypes
    var charBloodTypes: CGSSCharBloodTypes
    var charCVTypes: CGSSCharCVTypes
    var favoriteTypes: CGSSFavoriteTypes
    init(typeMask: UInt, ageMask: UInt, bloodMask: UInt, cvMask: UInt, favoriteMask: UInt) {
        charTypes = CGSSCharTypes.init(rawValue: typeMask)
        charAgeTypes = CGSSCharAgeTypes.init(rawValue: ageMask)
        charBloodTypes = CGSSCharBloodTypes.init(rawValue: bloodMask)
        charCVTypes = CGSSCharCVTypes.init(rawValue: cvMask)
        favoriteTypes = CGSSFavoriteTypes.init(rawValue: favoriteMask)
    }
    
    func filterCharList(_ charList: [CGSSChar]) -> [CGSSChar] {
        let result = charList.filter { (v: CGSSChar) -> Bool in
            if charTypes.contains(v.charType) && charAgeTypes.contains(v.charAgeType) && charBloodTypes.contains(v.charBloodType) && charCVTypes.contains(v.charCVType) && favoriteTypes.contains(v.favoriteType) {
                return true
            }
            return false
        }
        return result
    }
    
    func writeToFile(_ path: String) {
        
        let dict = ["typeMask": charTypes.rawValue, "ageMask": charAgeTypes, "bloodMask": charBloodTypes, "cvMask": charCVTypes, "favoriteMask": favoriteTypes] as NSDictionary
        dict.write(toFile: path, atomically: true)
    }
    
    static func readFromFile(_ path: String) -> CGSSCharFilter? {
        if let dict = NSDictionary.init(contentsOfFile: path) {
            if let typeMask = dict.object(forKey: "typeMask") as? UInt, let ageMask = dict.object(forKey: "ageMask") as? UInt, let bloodMask = dict.object(forKey: "bloodMask") as? UInt, let cvMask = dict.object(forKey: "cvMask") as? UInt, let favoriteMask = dict.object(forKey: "favoriteMask") as? UInt {
                return CGSSCharFilter.init(typeMask: typeMask, ageMask: ageMask, bloodMask: bloodMask, cvMask: cvMask, favoriteMask: favoriteMask)
            }
        }
        return nil
    }
}
