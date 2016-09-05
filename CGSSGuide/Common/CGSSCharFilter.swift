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
    case Ten = 1
    case Twenty = 2
    case Thirty = 4
    case ThirtyPlus = 8
    case Unknown = 16
    init(age: Int) {
        // 5009安部菜菜
        if [5009].contains(age) { self = .Unknown }
        else if age < 10 { self = .Ten }
        else if age < 20 { self = .Twenty }
        else if age < 30 { self = .Thirty }
        else if age >= 30 { self = .ThirtyPlus }
        else { self = .Unknown }
    }
    init? (raw: Int) {
        self.init(rawValue: UInt(raw))
    }
}

enum CGSSCharBloodFilterType: UInt {
    case A = 1
    case B = 2
    case AB = 4
    case O = 8
    case Other = 16
    init? (raw: Int) {
        self.init(rawValue: UInt(raw))
    }
    init (bloodType: Int) {
        switch bloodType {
        case 2001: self = .A
        case 2002: self = .B
        case 2003: self = .AB
        case 2004: self = .O
        default: self = .Other
        }
    }
}

enum CGSSCharCVTypeFilter: UInt {
    case YES = 1
    case NO = 2
    init? (raw: Int) {
        self.init(rawValue: UInt(raw))
    }
}

public class CGSSCharFilter {
    
    var charFilterTypes = [CGSSCharFilterType]()
    var charAgeFilterTypes = [CGSSCharAgeFilterType]()
    var charBloodTypeFilterTypes = [CGSSCharBloodFilterType]()
    var charCVFilterTypes = [CGSSCharCVTypeFilter]()
    public init(typeMask: UInt, ageMask: UInt, bloodMask: UInt, cvMask: UInt) {
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
    }
    
    func addCharFilterType(filterType: CGSSCharFilterType) {
        self.charFilterTypes.append(filterType)
    }
    func addCharAgeFilterType(filterType: CGSSCharAgeFilterType) {
        charAgeFilterTypes.append(filterType)
    }
    func addCharBloodFilterType(filterType: CGSSCharBloodFilterType) {
        charBloodTypeFilterTypes.append(filterType)
    }
    func addCharCVFilterType(filterType: CGSSCharCVTypeFilter) {
        charCVFilterTypes.append(filterType)
    }
    
    func removeCharFilterType(filterType: CGSSCharFilterType) {
        if let index = self.charFilterTypes.indexOf(filterType) {
            self.charFilterTypes.removeAtIndex(index)
        }
    }
    func removeCharAgeFilterType(filterType: CGSSCharAgeFilterType) {
        if let index = self.charAgeFilterTypes.indexOf(filterType) {
            self.charAgeFilterTypes.removeAtIndex(index)
        }
    }
    func removeCharBloodFilterType(filterType: CGSSCharBloodFilterType) {
        if let index = self.charBloodTypeFilterTypes.indexOf(filterType) {
            self.charBloodTypeFilterTypes.removeAtIndex(index)
        }
    }
    func removeCharCVFilterType(filterType: CGSSCharCVTypeFilter) {
        if let index = self.charCVFilterTypes.indexOf(filterType) {
            self.charCVFilterTypes.removeAtIndex(index)
        }
    }
    
    func hasCharFilterType(filterType: CGSSCharFilterType) -> Bool {
        return self.charFilterTypes.contains(filterType)
    }
    func hasCharAgeFilterType(filterType: CGSSCharAgeFilterType) -> Bool {
        return self.charAgeFilterTypes.contains(filterType)
    }
    func hasCharBloodFilterType(filterType: CGSSCharBloodFilterType) -> Bool {
        return self.charBloodTypeFilterTypes.contains(filterType)
    }
    func hasCharCVFilterType(filterType: CGSSCharCVTypeFilter) -> Bool {
        return self.charCVFilterTypes.contains(filterType)
    }
    
    func filterCharList(charList: [CGSSChar]) -> [CGSSChar] {
        let result = charList.filter { (v: CGSSChar) -> Bool in
            if charFilterTypes.contains(v.charFilterType) && charAgeFilterTypes.contains(v.charAgeFilterType) && charBloodTypeFilterTypes.contains(v.charBloodFilterType) && charCVFilterTypes.contains(v.charCVFilterType) {
                return true
            }
            return false
        }
        return result
    }
    
    func writeToFile(path: String) {
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
        
        let dict = ["typeMask": typeMask, "ageMask": ageMask, "bloodMask": bloodMask, "cvMask": cvMask] as NSDictionary
        dict.writeToFile(path, atomically: true)
    }
    
    static func readFromFile(path: String) -> CGSSCharFilter? {
        if let dict = NSDictionary.init(contentsOfFile: path) {
            if let typeMask = dict.objectForKey("typeMask") as? UInt, ageMask = dict.objectForKey("ageMask") as? UInt, bloodMask = dict.objectForKey("bloodMask") as? UInt, cvMask = dict.objectForKey("cvMask") as? UInt {
                return CGSSCharFilter.init(typeMask: typeMask, ageMask: ageMask, bloodMask: bloodMask, cvMask: cvMask)
            }
        }
        return nil
    }
}
