//
//  CGSSTypes.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

struct CGSSSkillTypes:OptionSet {
    let rawValue:UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let comboBonus = CGSSSkillTypes.init(rawValue: 1 << 0)
    static let perfectBonus = CGSSSkillTypes.init(rawValue: 1 << 1)
    static let overload = CGSSSkillTypes.init(rawValue: 1 << 2)
    static let perfectLock = CGSSSkillTypes.init(rawValue: 1 << 3)
    static let comboContinue = CGSSSkillTypes.init(rawValue: 1 << 4)
    static let heal = CGSSSkillTypes.init(rawValue: 1 << 5)
    static let `guard` = CGSSSkillTypes.init(rawValue: 1 << 6)
    static let none = CGSSSkillTypes.init(rawValue: 1 << 7)
    static let all = CGSSSkillTypes.init(rawValue: 0b11111111)
    init (typeString: String) {
        switch typeString {
        case "COMBO加成":
            self = .comboBonus
        case "分数加成", "PERFECT分数加成":
            self = .perfectBonus
        case "中级强判", "高级强判", "初级强判":
            self = .perfectLock
        case "COMBO保护":
            self = .comboContinue
        case "恢复生命":
            self = .heal
        case "锁血":
            self = .guard
        case "过载":
            self = .overload
        default:
            self = .none
        }
    }
    func toString() -> String {
        switch self {
        case CGSSSkillTypes.comboBonus:
            return NSLocalizedString("Combo加成", comment: "")
        case CGSSSkillTypes.perfectBonus:
            return NSLocalizedString("分数加成", comment: "")
        case CGSSSkillTypes.perfectLock:
            return NSLocalizedString("强判", comment: "")
        case CGSSSkillTypes.comboContinue:
            return NSLocalizedString("Combo保护", comment: "")
        case CGSSSkillTypes.heal:
            return NSLocalizedString("恢复生命", comment: "")
        case CGSSSkillTypes.guard:
            return NSLocalizedString("锁血", comment: "")
        case CGSSSkillTypes.overload:
            return NSLocalizedString("过载", comment: "")
        case CGSSSkillTypes.all:
            return NSLocalizedString("全部", comment: "")
        default:
            return NSLocalizedString("无", comment: "")
        }
    }
}

struct CGSSCardTypes: OptionSet, RawRepresentable, Hashable {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let cute = CGSSCardTypes.init(rawValue: 1 << 0)
    static let cool = CGSSCardTypes.init(rawValue: 1 << 1)
    static let passion = CGSSCardTypes.init(rawValue: 1 << 2)
    static let office = CGSSCardTypes.init(rawValue: 1 << 3)
    static let all = CGSSCardTypes.init(rawValue: 0b111)
    static let allSong = CGSSCardTypes.init(rawValue: 0b1111)
    
    init (type: Int) {
        self.init(rawValue: 1 << UInt(type))
    }
    init (typeString: String) {
        switch typeString {
        case "cute":
            self = .cute
        case "cool":
            self = .cool
        case "passion":
            self = .passion
        case "office":
            self = .office
        default:
            self = .office
        }
    }
    init (grooveType: CGSSGrooveType) {
        switch grooveType {
        case .cute:
            self = .cute
        case .cool:
            self = .cool
        case .passion:
            self = .passion
        }
    }
    
    var hashValue: Int {
        return Int(self.rawValue)
    }
    
}

struct CGSSAvailableTypes: OptionSet, RawRepresentable {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let normal = CGSSAvailableTypes.init(rawValue: 1 << 2)
    static let event = CGSSAvailableTypes.init(rawValue: 1 << 3)
    static let limit = CGSSAvailableTypes.init(rawValue: 1 << 1)
    static let fes = CGSSAvailableTypes.init(rawValue: 1 << 0)
    static let free = CGSSAvailableTypes.init(rawValue: 1 << 4)
    static let all = CGSSAvailableTypes.init(rawValue: 0b11111)
    
    func toString() -> String {
        switch self {
        case CGSSAvailableTypes.normal:
            return NSLocalizedString("普池", comment: "")
        case CGSSAvailableTypes.event:
            return NSLocalizedString("活动", comment: "")
        case CGSSAvailableTypes.limit:
            return NSLocalizedString("限定", comment: "")
        case CGSSAvailableTypes.fes:
            return NSLocalizedString("FES限定", comment: "")
        default:
            return NSLocalizedString("其他", comment: "")
        }
    }
}

struct CGSSAttributeTypes: OptionSet, RawRepresentable {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let vocal = CGSSAttributeTypes.init(rawValue: 1 << 0)
    static let dance = CGSSAttributeTypes.init(rawValue: 1 << 1)
    static let visual = CGSSAttributeTypes.init(rawValue: 1 << 2)
    static let none = CGSSAttributeTypes.init(rawValue: 1 << 3)
    static let all = CGSSAttributeTypes.init(rawValue: 0b111)
    init (type: Int) {
        self.init(rawValue: 1 << UInt(type))
    }
}


struct CGSSRarityTypes: OptionSet, RawRepresentable, Hashable {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let n = CGSSRarityTypes.init(rawValue: 1 << 0)
    static let np = CGSSRarityTypes.init(rawValue: 1 << 1)
    static let r = CGSSRarityTypes.init(rawValue: 1 << 2)
    static let rp = CGSSRarityTypes.init(rawValue: 1 << 3)
    static let sr = CGSSRarityTypes.init(rawValue: 1 << 4)
    static let srp = CGSSRarityTypes.init(rawValue: 1 << 5)
    static let ssr = CGSSRarityTypes.init(rawValue: 1 << 6)
    static let ssrp = CGSSRarityTypes.init(rawValue: 1 << 7)
    static let all = CGSSRarityTypes.init(rawValue: 0b11111111)
    
    init (rarity: Int) {
        self.init(rawValue: 1 << UInt(rarity))
    }
    var hashValue: Int {
        return Int(self.rawValue)
    }
//    static func == (lhs: CGSSRarityTypes, rhs: CGSSRarityTypes) -> Bool {
//        return lhs.hashValue == rhs.hashValue
//    }
}

struct CGSSFavoriteTypes: OptionSet, RawRepresentable {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let inFavorite = CGSSFavoriteTypes.init(rawValue: 1 << 0)
    static let notInFavorite = CGSSFavoriteTypes.init(rawValue: 1 << 1)
    static let all = CGSSFavoriteTypes.init(rawValue: 0b11)
}

struct CGSSProcTypes: OptionSet, RawRepresentable, Hashable {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let low = CGSSProcTypes.init(rawValue: 1 << 2)
    static let middle = CGSSProcTypes.init(rawValue: 1 << 1)
    static let high = CGSSProcTypes.init(rawValue: 1 << 0)
    static let none = CGSSProcTypes.init(rawValue: 1 << 3)
    static let all = CGSSProcTypes.init(rawValue: 0b1111)
   
    var hashValue: Int {
        return Int(self.rawValue)
    }

    func toString() -> String {
        switch self {
        case CGSSProcTypes.low:
            return NSLocalizedString("低确率", comment: "")
        case CGSSProcTypes.middle:
            return NSLocalizedString("中确率", comment: "")
        case CGSSProcTypes.high:
            return NSLocalizedString("高确率", comment: "")
        default:
            return NSLocalizedString("无", comment: "")
        }
    }
}

struct CGSSConditionTypes: OptionSet, RawRepresentable, Hashable {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let c4 = CGSSConditionTypes.init(rawValue: 1 << 0)
    static let c6 = CGSSConditionTypes.init(rawValue: 1 << 1)
    static let c7 = CGSSConditionTypes.init(rawValue: 1 << 2)
    static let c9 = CGSSConditionTypes.init(rawValue: 1 << 3)
    static let c11 = CGSSConditionTypes.init(rawValue: 1 << 4)
    static let c13 = CGSSConditionTypes.init(rawValue: 1 << 5)
    static let other = CGSSConditionTypes.init(rawValue: 1 << 6)
    static let all = CGSSConditionTypes.init(rawValue: 0b1111111)
    var hashValue: Int {
        return Int(self.rawValue)
    }
    
    func toString() -> String {
        switch self {
        case CGSSConditionTypes.c4:
            return "4" + NSLocalizedString("秒", comment: "")
        case CGSSConditionTypes.c6:
            return "6" + NSLocalizedString("秒", comment: "")
        case CGSSConditionTypes.c7:
            return "7" + NSLocalizedString("秒", comment: "")
        case CGSSConditionTypes.c9:
            return "9" + NSLocalizedString("秒", comment: "")
        case CGSSConditionTypes.c11:
            return "11" + NSLocalizedString("秒", comment: "")
        case CGSSConditionTypes.c13:
            return "13" + NSLocalizedString("秒", comment: "")
        default:
            return NSLocalizedString("其他", comment: "")
        }
    }
}



typealias CGSSCharTypes = CGSSCardTypes

struct CGSSCharAgeTypes: OptionSet, RawRepresentable {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let ten = CGSSCharAgeTypes.init(rawValue: 1 << 0)
    static let twenty = CGSSCharAgeTypes.init(rawValue: 1 << 1)
    static let thirty = CGSSCharAgeTypes.init(rawValue: 1 << 2)
    static let thirtyPlus = CGSSCharAgeTypes.init(rawValue: 1 << 3)
    static let unknown = CGSSCharAgeTypes.init(rawValue: 1 << 4)
    static let all = CGSSCharAgeTypes.init(rawValue: 0b11111)
    init(age: Int) {
        // 5009安部菜菜
        if [5009].contains(age) { self = .unknown }
        else if age < 10 { self = .ten }
        else if age < 20 { self = .twenty }
        else if age < 30 { self = .thirty }
        else if age >= 30 { self = .thirtyPlus }
        else { self = .unknown }
    }
}

struct CGSSCharBloodTypes: OptionSet, RawRepresentable {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let a = CGSSCharBloodTypes.init(rawValue: 1 << 0)
    static let b = CGSSCharBloodTypes.init(rawValue: 1 << 1)
    static let ab = CGSSCharBloodTypes.init(rawValue: 1 << 2)
    static let o = CGSSCharBloodTypes.init(rawValue: 1 << 3)
    static let other = CGSSCharBloodTypes.init(rawValue: 1 << 4)
    static let all = CGSSCharBloodTypes.init(rawValue: 0b11111)
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


struct CGSSCharCVTypes: OptionSet, RawRepresentable {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let yes = CGSSCharCVTypes.init(rawValue: 1 << 0)
    static let no = CGSSCharCVTypes.init(rawValue: 1 << 1)
    static let all = CGSSCharCVTypes.init(rawValue: 0b11)
}

typealias CGSSSongTypes = CGSSCardTypes

struct CGSSSongEventTypes: OptionSet, RawRepresentable {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let normal = CGSSSongEventTypes.init(rawValue: 1 << 0)
    static let tradition = CGSSSongEventTypes.init(rawValue: 1 << 1)
    static let groove = CGSSSongEventTypes.init(rawValue: 1 << 2)
    static let parade = CGSSSongEventTypes.init(rawValue: 1 << 3)
    static let all = CGSSSongEventTypes.init(rawValue: 0b1111)
    init (eventType: Int) {
        switch eventType {
        case 0:
            self = .normal
        case 1:
            self = .tradition
        case 3:
            self = .groove
        case 5:
            self = .parade
        default:
            self = .normal
        }
    }
}



struct CGSSEventTypes: OptionSet, RawRepresentable {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let tradition = CGSSEventTypes.init(rawValue: 1 << 0)
    static let groove = CGSSEventTypes.init(rawValue: 1 << 2)
    static let parade = CGSSEventTypes.init(rawValue: 1 << 4)
    static let kyalapon = CGSSEventTypes.init(rawValue: 1 << 1)
    static let party = CGSSEventTypes.init(rawValue: 1 << 3)
    static let all = CGSSEventTypes.init(rawValue: 0b11111)
    init (eventType: Int) {
        self.rawValue = 1 << UInt(eventType - 1)
    }
    func toString() -> String {
        switch self {
        case CGSSEventTypes.tradition:
            return NSLocalizedString("传统活动", comment: "")
        case CGSSEventTypes.groove:
            return NSLocalizedString("Groove活动", comment: "")
        case CGSSEventTypes.kyalapon:
            return NSLocalizedString("篷车活动", comment: "")
        case CGSSEventTypes.party:
            return NSLocalizedString("协力活动", comment: "")
        case CGSSEventTypes.parade:
            return NSLocalizedString("巡演活动", comment: "")
        default:
            return NSLocalizedString("未知", comment: "")
        }
    }
}

