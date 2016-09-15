//
//  CGSSCardFilter.swift
//  CGSSFoundation
//
//  Created by zzk on 16/7/2.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

enum CGSSSkillFilterType: UInt {
    case comboBonus = 1
    case perfectBonus = 2
    case overload = 4
    case perfectLock = 8
    case comboContinue = 16
    case heal = 32
    case `guard` = 64
    case none = 128
    case other = 256
    init (type: String) {
        switch type {
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
            self = .other
        }
    }
    init?(raw: UInt) {
        self.init(rawValue: raw)
    }
}

public enum CGSSCardFilterType: UInt {
    case cute = 1
    case cool = 2
    case passion = 4
    case office = 8
    init? (cardType: Int) {
        self.init(rawValue: 1 << UInt(cardType))
    }
    init?(raw: UInt) {
        self.init(rawValue: raw)
    }
    init? (typeString: String) {
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
    init? (grooveType: CGSSGrooveType) {
        switch grooveType {
        case .Cute:
            self = .cute
        case .Cool:
            self = .cool
        case .Passion:
            self = .passion
        }
    }
}

public enum CGSSAttributeFilterType: UInt {
    case vocal = 1
    case dance = 2
    case visual = 4
    case none = 8
    init? (attributeType: Int) {
        self.init(rawValue: 1 << UInt(attributeType))
    }
}

public enum CGSSCardRarityFilterType: UInt {
    case n = 1
    case np = 2
    case r = 4
    case rp = 8
    case sr = 16
    case srp = 32
    case ssr = 64
    case ssrp = 128
    
    public init? (rarity: Int) {
        self.init(rawValue: 1 << UInt(rarity))
    }
}

public enum CGSSFavoriteFilterType: UInt {
    case inFavorite = 1
    case notInFavorite = 2
    
    public init? (rawValue: UInt) {
        if rawValue == 1 {
            self = .inFavorite
        } else {
            self = .notInFavorite
        }
    }
}

open class CGSSCardFilter {
    
    var cardFilterTypes = [CGSSCardFilterType]()
    var attributeFilterTypes = [CGSSAttributeFilterType]()
    var rarityFilterTypes = [CGSSCardRarityFilterType]()
    var skillFilterTypes = [CGSSSkillFilterType]()
    var favoriteFilterTypes = [CGSSFavoriteFilterType]()
    public init(cardMask: UInt, attributeMask: UInt, rarityMask: UInt, skillMask: UInt, favoriteMask: UInt?) {
        for i: UInt in 0...3 {
            let mask = cardMask >> i
            if mask % 2 == 1 {
                cardFilterTypes.append(CGSSCardFilterType.init(rawValue: 1 << i)!)
            }
        }
        
        for i: UInt in 0...3 {
            let mask = attributeMask >> i
            if mask % 2 == 1 {
                attributeFilterTypes.append(CGSSAttributeFilterType.init(rawValue: 1 << i)!)
            }
        }
        
        for i: UInt in 0...7 {
            let mask = rarityMask >> i
            if mask % 2 == 1 {
                rarityFilterTypes.append(CGSSCardRarityFilterType.init(rawValue: 1 << i)!)
            }
        }
        for i: UInt in 0...8 {
            let mask = skillMask >> i
            if mask % 2 == 1 {
                skillFilterTypes.append(CGSSSkillFilterType.init(rawValue: 1 << i)!)
            }
        }
        for i: UInt in 0...1 {
            let mask = (favoriteMask ?? 0b11) >> i
            if mask % 2 == 1 {
                favoriteFilterTypes.append(CGSSFavoriteFilterType.init(rawValue: 1 << i)!)
            }
        }
    }
    
    func addCardFilterType(_ filterType: CGSSCardFilterType) {
        self.cardFilterTypes.append(filterType)
    }
    func addCardRarityFilterType(_ filterType: CGSSCardRarityFilterType) {
        self.rarityFilterTypes.append(filterType)
    }
    func addAttributeFilterType(_ filterType: CGSSAttributeFilterType) {
        self.attributeFilterTypes.append(filterType)
    }
    func addFavoriteFilterType(_ filterType: CGSSFavoriteFilterType) {
        self.favoriteFilterTypes.append(filterType)
    }
    func addSkillFilterType(_ filterType: CGSSSkillFilterType) {
        self.skillFilterTypes.append(filterType)
    }
    
    func removeCardFilterType(_ filterType: CGSSCardFilterType) {
        if let index = self.cardFilterTypes.index(of: filterType) {
            self.cardFilterTypes.remove(at: index)
        }
    }
    func removeAttributeFilterType(_ filterType: CGSSAttributeFilterType) {
        if let index = self.attributeFilterTypes.index(of: filterType) {
            self.attributeFilterTypes.remove(at: index)
        }
    }
    func removeCardRarityFilterType(_ filterType: CGSSCardRarityFilterType) {
        if let index = self.rarityFilterTypes.index(of: filterType) {
            self.rarityFilterTypes.remove(at: index)
        }
    }
    func removeFavoriteFilterType(_ filterType: CGSSFavoriteFilterType) {
        if let index = self.favoriteFilterTypes.index(of: filterType) {
            self.favoriteFilterTypes.remove(at: index)
        }
    }
    
    func removeSkillFilterType(_ filterType: CGSSSkillFilterType) {
        if let index = self.skillFilterTypes.index(of: filterType) {
            self.skillFilterTypes.remove(at: index)
        }
    }
    
    func hasCardFilterType(_ cardFilterType: CGSSCardFilterType) -> Bool {
        return self.cardFilterTypes.contains(cardFilterType)
    }
    func hasAttributeFilterType(_ attributeFilterType: CGSSAttributeFilterType) -> Bool {
        return self.attributeFilterTypes.contains(attributeFilterType)
    }
    func hasCardRarityFilterType(_ cardRarityFilterType: CGSSCardRarityFilterType) -> Bool {
        return self.rarityFilterTypes.contains(cardRarityFilterType)
    }
    func hasFavoriteFilterType(_ favoriteFilterType: CGSSFavoriteFilterType) -> Bool {
        return self.favoriteFilterTypes.contains(favoriteFilterType)
    }
    func hasSkillFilterType(_ filterType: CGSSSkillFilterType) -> Bool {
        return self.skillFilterTypes.contains(filterType)
    }
    
    func filterCardList(_ cardList: [CGSSCard]) -> [CGSSCard] {
        let result = cardList.filter { (v: CGSSCard) -> Bool in
            if cardFilterTypes.contains(v.cardFilterType) && attributeFilterTypes.contains(v.attributeFilterType) && rarityFilterTypes.contains(v.rarityFilterType) && favoriteFilterTypes.contains(v.favoriteFilterType) && skillFilterTypes.contains(v.skillFilterType) {
                return true
            }
            return false
        }
        return result
    }
    
    func writeToFile(_ path: String) {
        var cardMask: UInt = 0
        for type in cardFilterTypes {
            cardMask += type.rawValue
        }
        var attributeMask: UInt = 0
        for type in attributeFilterTypes {
            attributeMask += type.rawValue
        }
        var rarityMask: UInt = 0
        for type in rarityFilterTypes {
            rarityMask += type.rawValue
        }
        var favoriteMask: UInt = 0
        for type in favoriteFilterTypes {
            favoriteMask += type.rawValue
        }
        var skillMask: UInt = 0
        for type in skillFilterTypes {
            skillMask += type.rawValue
        }
        
        let dict = ["cardMask": cardMask, "attributeMask": attributeMask, "rarityMask": rarityMask, "favoriteMask": favoriteMask, "skillMask": skillMask] as NSDictionary
        dict.write(toFile: path, atomically: true)
    }
    
    static func readFromFile(_ path: String) -> CGSSCardFilter? {
        if let dict = NSDictionary.init(contentsOfFile: path) {
            if let cardMask = dict.object(forKey: "cardMask") as? UInt, let attributeMask = dict.object(forKey: "attributeMask") as? UInt, let rarityMask = dict.object(forKey: "rarityMask") as? UInt, let favoriteMask = dict.object(forKey: "favoriteMask") as? UInt, let skillMask = dict.object(forKey: "skillMask") as? UInt {
                return CGSSCardFilter.init(cardMask: cardMask, attributeMask: attributeMask, rarityMask: rarityMask,skillMask: skillMask, favoriteMask: favoriteMask)
            }
        }
        return nil
    }
}
