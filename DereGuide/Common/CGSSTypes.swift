//
//  CGSSTypes.swift
//  DereGuide
//
//  Created by zzk on 2016/9/23.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

struct CGSSSkillTypes: OptionSet, CustomStringConvertible {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let comboBonus = CGSSSkillTypes.init(rawValue: 1 << 0)
    static let perfectBonus = CGSSSkillTypes.init(rawValue: 1 << 1)
    static let overload = CGSSSkillTypes.init(rawValue: 1 << 2)
    static let perfectLock = CGSSSkillTypes.init(rawValue: 1 << 3)
    static let comboContinue = CGSSSkillTypes.init(rawValue: 1 << 4)
    static let heal = CGSSSkillTypes.init(rawValue: 1 << 5)
    static let `guard` = CGSSSkillTypes.init(rawValue: 1 << 6)
    
    static let concentration = CGSSSkillTypes.init(rawValue: 1 << 7)
    static let boost = CGSSSkillTypes.init(rawValue: 1 << 8)
    static let allRound = CGSSSkillTypes.init(rawValue: 1 << 9)
    static let deep = CGSSSkillTypes.init(rawValue: 1 << 10)
    
    static let encore = CGSSSkillTypes.init(rawValue: 1 << 11)
    static let lifeSparkle = CGSSSkillTypes.init(rawValue: 1 << 12)
    
    static let synergy = CGSSSkillTypes(rawValue: 1 << 13)

    static let unknown = CGSSSkillTypes.init(rawValue: 1 << 14)
    static let none = CGSSSkillTypes.init(rawValue: 1 << 15)
    
    static let all = CGSSSkillTypes.init(rawValue: 0b1111_1111_1111_1111)
    
    init(typeID: Int) {
        switch typeID {
        case 1, 2, 3:
            self = .perfectBonus
        case 4:
            self = .comboBonus
        case 5, 6, 7, 8:
            self = .perfectLock
        case 9, 10, 11:
            self = .comboContinue
        case 12:
            self = .guard
        case 13, 17, 18, 19:
            self = .heal
        case 14:
            self = .overload
        case 15:
            self = .concentration
        case 16:
            self = .encore
        case 20:
            self = .boost
        case 21, 22, 23:
            self = .deep
        case 24:
            self = .allRound
        case 25:
            self = .lifeSparkle
        case 26:
            self = .synergy
        default:
            self = .unknown
        }
    }
    
    var description: String {
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
        case CGSSSkillTypes.none:
            return NSLocalizedString("无", comment: "")
        case CGSSSkillTypes.concentration:
            return NSLocalizedString("专注", comment: "")
        case CGSSSkillTypes.encore:
            return NSLocalizedString("返场", comment: "")
        case CGSSSkillTypes.lifeSparkle:
            return NSLocalizedString("生命闪耀", comment: "")
        case CGSSSkillTypes.allRound:
            return NSLocalizedString("全才", comment: "")
        case CGSSSkillTypes.deep:
            return NSLocalizedString("集中", comment: "")
        case CGSSSkillTypes.boost:
            return NSLocalizedString("Skill Boost", comment: "")
        case CGSSSkillTypes.synergy:
            return NSLocalizedString("三色协同", comment: "")
        default:
            return NSLocalizedString("未知", comment: "")
        }
    }
}

struct CGSSLeaderSkillTypes: OptionSet, CustomStringConvertible {
    var rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let vocalUp = CGSSLeaderSkillTypes(rawValue: 1 << 0)
    static let danceUp = CGSSLeaderSkillTypes(rawValue: 1 << 1)
    static let visualUp =  CGSSLeaderSkillTypes(rawValue: 1 << 2)
    static let allAppealUp = CGSSLeaderSkillTypes(rawValue: 1 << 3)
    static let lifeUp = CGSSLeaderSkillTypes(rawValue: 1 << 4)
    static let procUp =  CGSSLeaderSkillTypes(rawValue: 1 << 5)
    static let threeColor = CGSSLeaderSkillTypes(rawValue: 1 << 6)
    static let princess = CGSSLeaderSkillTypes(rawValue: 1 << 7)
    static let unknown = CGSSLeaderSkillTypes(rawValue: 1 << 8)
    static let all =  CGSSLeaderSkillTypes(rawValue: 0b1_1111_1111)

    init(type: Int, upType: Int, targetAttribute: Int, targetParams: Int, needCute: Int, needCool: Int, needPassion: Int) {
        if upType == 1 && type == 20 {
            if needCute == 6 || needCool == 6 || needPassion == 6 {
                self = .threeColor
            } else if targetParams == 1 {
                
            }
        } else {
            self = .unknown
        }
        
        self = .unknown
    }
    
    var description: String {
        return ""
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
    
    init(type: Int) {
        self.init(rawValue: 1 << UInt(type))
    }
    
    init(typeString: String) {
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
    
    var hashValue: Int {
        return Int(self.rawValue)
    }
    
}

struct CGSSAvailableTypes: OptionSet, CustomStringConvertible {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let normal = CGSSAvailableTypes.init(rawValue: 1 << 2)
    static let event = CGSSAvailableTypes.init(rawValue: 1 << 3)
    static let limit = CGSSAvailableTypes.init(rawValue: 1 << 1)
    static let fes = CGSSAvailableTypes.init(rawValue: 1 << 0)
    static let free = CGSSAvailableTypes.init(rawValue: 1 << 4)
    static let all = CGSSAvailableTypes.init(rawValue: 0b11111)
    
    var description: String {
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

struct CGSSAttributeTypes: OptionSet {
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
    
    var color: UIColor {
        switch self {
        case CGSSAttributeTypes.vocal:
            return .vocal
        case CGSSAttributeTypes.dance:
            return .dance
        case CGSSAttributeTypes.visual:
            return .visual
        default:
            return .allType
        }
    }
    
    var short: String {
        switch self {
        case CGSSAttributeTypes.vocal:
            return "Vo"
        case CGSSAttributeTypes.dance:
            return "Da"
        case CGSSAttributeTypes.visual:
            return "Vi"
        default:
            return ""
        }
    }
}

struct CGSSRarityTypes: OptionSet, Hashable {
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
    
}

struct CGSSFavoriteTypes: OptionSet {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let inFavorite = CGSSFavoriteTypes.init(rawValue: 1 << 0)
    static let notInFavorite = CGSSFavoriteTypes.init(rawValue: 1 << 1)
    static let all: CGSSFavoriteTypes = [.inFavorite, .notInFavorite]
}

struct CGSSProcTypes: OptionSet, Hashable, CustomStringConvertible {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let low = CGSSProcTypes.init(rawValue: 1 << 2)
    static let middle = CGSSProcTypes.init(rawValue: 1 << 1)
    static let high = CGSSProcTypes.init(rawValue: 1 << 0)
    static let none = CGSSProcTypes.init(rawValue: 1 << 3)
    static let all: CGSSProcTypes = [.low, .middle, .high, .none]
   
    var hashValue: Int {
        return Int(self.rawValue)
    }

    var description: String {
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

struct CGSSConditionTypes: OptionSet, Hashable, CustomStringConvertible {
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
    
    var description: String {
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

struct CGSSPositionNumberTypes: OptionSet, CustomStringConvertible {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let n1 = CGSSPositionNumberTypes(rawValue: 1 << 0)
    static let n2 = CGSSPositionNumberTypes(rawValue: 1 << 1)
    static let n3 = CGSSPositionNumberTypes(rawValue: 1 << 2)
    static let n4 = CGSSPositionNumberTypes(rawValue: 1 << 3)
    static let n5 = CGSSPositionNumberTypes(rawValue: 1 << 4)
    static let nm = CGSSPositionNumberTypes(rawValue: 1 << 5)
  
    static let all = CGSSPositionNumberTypes(rawValue: 0b111111)
    
    init(positionNum: Int) {
        if positionNum > 0 {
            self.init(rawValue: 1 << UInt(positionNum - 1))
        } else {
            self.init(rawValue: 1 << 5)
        }
    }
    
    var description: String {
        switch self {
        case CGSSPositionNumberTypes.n1:
            return NSLocalizedString("Solo", comment: "")
        case CGSSPositionNumberTypes.n2:
            return "2" + NSLocalizedString("人组合", comment: "")
        case CGSSPositionNumberTypes.n3:
            return "3" + NSLocalizedString("人组合", comment: "")
        case CGSSPositionNumberTypes.n4:
            return "4" + NSLocalizedString("人组合", comment: "")
        case CGSSPositionNumberTypes.n5:
            return "5" + NSLocalizedString("人组合", comment: "")
       default:
            return NSLocalizedString("其他", comment: "")
        }
    }
}

typealias CGSSCharTypes = CGSSCardTypes

struct CGSSCharAgeTypes: OptionSet {
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

struct CGSSCharBloodTypes: OptionSet {
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


struct CGSSCharCVTypes: OptionSet {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let yes = CGSSCharCVTypes.init(rawValue: 1 << 0)
    static let no = CGSSCharCVTypes.init(rawValue: 1 << 1)
    static let all = CGSSCharCVTypes.init(rawValue: 0b11)
}

typealias CGSSLiveTypes = CGSSCardTypes
extension CGSSLiveTypes {
    static let allType = CGSSLiveTypes.office
    static let allLives: CGSSLiveTypes = [.cute, .cool, .passion, .allType]
    
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
    
    var icon: UIImage? {
        switch self {
        case CGSSLiveTypes.cute:
            return #imageLiteral(resourceName: "song-cute")
        case CGSSLiveTypes.cool:
            return #imageLiteral(resourceName: "song-cool")
        case CGSSLiveTypes.passion:
            return #imageLiteral(resourceName: "song-passion")
        case CGSSLiveTypes.allType:
            return #imageLiteral(resourceName: "song-all")
        default:
            return nil
        }
    }
    
    var color: UIColor {
        switch self {
        case CGSSLiveTypes.cute:
            return .cute
        case CGSSLiveTypes.cool:
            return .cool
        case CGSSLiveTypes.passion:
            return .passion
        default:
            return .allType
        }
    }
}

struct CGSSLiveEventTypes: OptionSet, CustomStringConvertible {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let normal = CGSSLiveEventTypes.init(rawValue: 1 << 0)
    static let tradition = CGSSLiveEventTypes.init(rawValue: 1 << 1)
    static let groove = CGSSLiveEventTypes.init(rawValue: 1 << 2)
    static let parade = CGSSLiveEventTypes.init(rawValue: 1 << 3)
    static let all = CGSSLiveEventTypes.init(rawValue: 0b1111)
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
    
    var description: String {
        switch self {
        case CGSSLiveEventTypes.normal:
            return NSLocalizedString("常规歌曲", comment: "")
        case CGSSLiveEventTypes.tradition:
            return NSLocalizedString("传统活动", comment: "")
        case CGSSLiveEventTypes.groove:
            return NSLocalizedString("Groove活动", comment: "")
        case CGSSLiveEventTypes.parade:
            return NSLocalizedString("巡演活动", comment: "")
        default:
            return NSLocalizedString("巡演活动", comment: "")
        }
    }
}



struct CGSSEventTypes: OptionSet, CustomStringConvertible {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let tradition = CGSSEventTypes.init(rawValue: 1 << 0)
    static let groove = CGSSEventTypes.init(rawValue: 1 << 2)
    static let parade = CGSSEventTypes.init(rawValue: 1 << 4)
    static let kyalapon = CGSSEventTypes.init(rawValue: 1 << 1)
    static let party = CGSSEventTypes.init(rawValue: 1 << 3)
    static let rail = CGSSEventTypes.init(rawValue: 1 << 5)
    static let all = CGSSEventTypes.init(rawValue: 0b111111)
    static let ptRankingExists: CGSSEventTypes = [.groove, .tradition]
    static let scoreRankingExists: CGSSEventTypes = [.groove, .tradition, .parade]
    static let hasSong: CGSSEventTypes = .scoreRankingExists
    init (eventType: Int) {
        self.rawValue = 1 << UInt(eventType - 1)
    }
    
    var description: String {
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
        case CGSSEventTypes.rail:
            return NSLocalizedString("灰姑娘之路", comment: "")
        default:
            return NSLocalizedString("未知", comment: "")
        }
    }
}


struct CGSSGachaTypes: OptionSet {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let normal = CGSSGachaTypes.init(rawValue: 1 << 0)
    static let limit = CGSSGachaTypes.init(rawValue: 1 << 1)
    static let fes = CGSSGachaTypes.init(rawValue: 1 << 2)
    static let singleType = CGSSGachaTypes.init(rawValue: 1 << 3)
    static let premium = CGSSGachaTypes(rawValue: 1 << 4)
    static let all = CGSSGachaTypes.init(rawValue: 0b11111)
    
    var description: String {
        switch self {
        case CGSSGachaTypes.limit:
            return NSLocalizedString("限定卡池", comment: "")
        case CGSSGachaTypes.fes:
            return NSLocalizedString("FES限定卡池", comment: "")
        case CGSSGachaTypes.singleType:
            return NSLocalizedString("单属性卡池", comment: "")
        case CGSSGachaTypes.premium:
            return NSLocalizedString("高级试音会", comment: "")
        default:
            return NSLocalizedString("普通试音会", comment: "")
        }
    }
}
