//
//  CGSSCharFilter.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/31.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

typealias CGSSCharFilterType = CGSSCardFilterType
enum CGSSCharAgeFilterType: UInt {
    case ten = 1
    case twenty = 2
    case thirty = 4
    case thirtyPlus = 8
    case unknown = 16
    init(age: Int) {
        // 5009安部菜菜
        if [5009].contains(age) { self = .unknown }
        else if age < 10 { self = .ten }
        else if age < 20 { self = .twenty }
        else if age < 30 { self = .thirty }
        else if age >= 30 { self = .thirtyPlus }
        else { self = .unknown }
    }
    init? (raw: Int) {
        self.init(rawValue: UInt(raw))
    }
}

enum CGSSCharBloodFilterType: UInt {
    case a = 1
    case b = 2
    case ab = 4
    case o = 8
    case other = 16
    init? (raw: Int) {
        self.init(rawValue: UInt(raw))
    }
    init (bloodType: Int) {
        switch bloodType {
        case 2001: self = .a
        case 2002: self = .b
        case 2003: self = .ab
        case 2004: self = .o
        default: self = .other
        }
    }
}

enum CGSSCharCVTypeFilter: UInt {
    case yes = 1
    case no = 2
    init? (raw: Int) {
        self.init(rawValue: UInt(raw))
    }
}

open class CGSSCharFilter {
    
    var charFilterTypes = [CGSSCharFilterType]()
    var charAgeFilterTypes = [CGSSCharAgeFilterType]()
    var charBloodTypeFilterTypes = [CGSSCharBloodFilterType]()
    var charCVFilterTypes = [CGSSCharCVTypeFilter]()
    var favoriteFilterTypes = [CGSSFavoriteFilterType]()
    public init(typeMask: UInt, ageMask: UInt, bloodMask: UInt, cvMask: UInt, favoriteMask: UInt) {
        for i: UInt in 0...3 {
            let mask = typeMask >> i
            if mask % 2 == 1 {
                charFilterTypes.append(CGSSCharFilterType.init(raw: 1 << i)!)
            }
        }
        
        for i: UInt in 0...4 {
            let mask = ageMask >> i
            if mask % 2 == 1 {
                charAgeFilterTypes.append(CGSSCharAgeFilterType.init(rawValue: 1 << i)!)
            }
        }
        for i: UInt in 0...4 {
            let mask = bloodMask >> i
            if mask % 2 == 1 {
                charBloodTypeFilterTypes.append(CGSSCharBloodFilterType.init(rawValue: 1 << i)!)
            }
        }
        for i: UInt in 0...1 {
            let mask = cvMask >> i
            if mask % 2 == 1 {
                charCVFilterTypes.append(CGSSCharCVTypeFilter.init(rawValue: 1 << i)!)
            }
        }
        for i: UInt in 0...1 {
            let mask = favoriteMask >> i
            if mask % 2 == 1 {
                favoriteFilterTypes.append(CGSSFavoriteFilterType.init(rawValue: 1 << i)!)
            }
        }
    }
    
    func addCharFilterType(_ filterType: CGSSCharFilterType) {
        self.charFilterTypes.append(filterType)
    }
    func addCharAgeFilterType(_ filterType: CGSSCharAgeFilterType) {
        charAgeFilterTypes.append(filterType)
    }
    func addCharBloodFilterType(_ filterType: CGSSCharBloodFilterType) {
        charBloodTypeFilterTypes.append(filterType)
    }
    func addCharCVFilterType(_ filterType: CGSSCharCVTypeFilter) {
        charCVFilterTypes.append(filterType)
    }
    func addFavoriteFilterType(_ filterType: CGSSFavoriteFilterType) {
        self.favoriteFilterTypes.append(filterType)
    }
    
    func removeCharFilterType(_ filterType: CGSSCharFilterType) {
        if let index = self.charFilterTypes.index(of: filterType) {
            self.charFilterTypes.remove(at: index)
        }
    }
    func removeCharAgeFilterType(_ filterType: CGSSCharAgeFilterType) {
        if let index = self.charAgeFilterTypes.index(of: filterType) {
            self.charAgeFilterTypes.remove(at: index)
        }
    }
    func removeCharBloodFilterType(_ filterType: CGSSCharBloodFilterType) {
        if let index = self.charBloodTypeFilterTypes.index(of: filterType) {
            self.charBloodTypeFilterTypes.remove(at: index)
        }
    }
    func removeCharCVFilterType(_ filterType: CGSSCharCVTypeFilter) {
        if let index = self.charCVFilterTypes.index(of: filterType) {
            self.charCVFilterTypes.remove(at: index)
        }
    }
    func removeFavoriteFilterType(_ filterType: CGSSFavoriteFilterType) {
        if let index = self.favoriteFilterTypes.index(of: filterType) {
            self.favoriteFilterTypes.remove(at: index)
        }
    }
    
    func hasCharFilterType(_ filterType: CGSSCharFilterType) -> Bool {
        return self.charFilterTypes.contains(filterType)
    }
    func hasCharAgeFilterType(_ filterType: CGSSCharAgeFilterType) -> Bool {
        return self.charAgeFilterTypes.contains(filterType)
    }
    func hasCharBloodFilterType(_ filterType: CGSSCharBloodFilterType) -> Bool {
        return self.charBloodTypeFilterTypes.contains(filterType)
    }
    func hasCharCVFilterType(_ filterType: CGSSCharCVTypeFilter) -> Bool {
        return self.charCVFilterTypes.contains(filterType)
    }
    func hasFavoriteFilterType(_ favoriteFilterType: CGSSFavoriteFilterType) -> Bool {
        return self.favoriteFilterTypes.contains(favoriteFilterType)
    }
    
    func filterCharList(_ charList: [CGSSChar]) -> [CGSSChar] {
        let result = charList.filter { (v: CGSSChar) -> Bool in
            if charFilterTypes.contains(v.charFilterType) && charAgeFilterTypes.contains(v.charAgeFilterType) && charBloodTypeFilterTypes.contains(v.charBloodFilterType) && charCVFilterTypes.contains(v.charCVFilterType) && favoriteFilterTypes.contains(v.favoriteFilterType) {
                return true
            }
            return false
        }
        return result
    }
    
    func writeToFile(_ path: String) {
        var typeMask: UInt = 0
        for type in charFilterTypes {
            typeMask += type.rawValue
        }
        var ageMask: UInt = 0
        for type in charAgeFilterTypes {
            ageMask += type.rawValue
        }
        var bloodMask: UInt = 0
        for type in charBloodTypeFilterTypes {
            bloodMask += type.rawValue
        }
        var cvMask: UInt = 0
        for type in charCVFilterTypes {
            cvMask += type.rawValue
        }
        var favoriteMask: UInt = 0
        for type in favoriteFilterTypes {
            favoriteMask += type.rawValue
        }
        
        let dict = ["typeMask": typeMask, "ageMask": ageMask, "bloodMask": bloodMask, "cvMask": cvMask, "favoriteMask": favoriteMask] as NSDictionary
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
