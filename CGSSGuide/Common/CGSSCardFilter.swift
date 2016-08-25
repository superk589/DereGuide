//
//  CGSSCardFilter.swift
//  CGSSFoundation
//
//  Created by zzk on 16/7/2.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

public enum CGSSCardFilterType: UInt {
    case Cute = 1
    case Cool = 2
    case Passion = 4
    case Office = 8
    init? (cardType: Int) {
        self.init(rawValue: 1 << UInt(cardType))
    }
    
    init? (typeString: String) {
        switch typeString {
        case "cute":
            self = .Cute
        case "cool":
            self = .Cool
        case "passion":
            self = .Passion
        case "office":
            self = .Office
        default:
            self = .Office
        }
    }
}

public enum CGSSAttributeFilterType: UInt {
    case Vocal = 1
    case Dance = 2
    case Visual = 4
    case None = 8
    init? (attributeType: Int) {
        self.init(rawValue: 1 << UInt(attributeType))
    }
}

public enum CGSSCardRarityFilterType: UInt {
    case N = 1
    case NP = 2
    case R = 4
    case RP = 8
    case SR = 16
    case SRP = 32
    case SSR = 64
    case SSRP = 128
    
    public init? (rarity: Int) {
        self.init(rawValue: 1 << UInt(rarity))
    }
}

public enum CGSSFavoriteFilterType: UInt {
    case InFavorite = 1
    case NotInFavorite = 2
    
    public init? (rawValue: UInt) {
        if rawValue == 1 {
            self = .InFavorite
        } else {
            self = .NotInFavorite
        }
    }
}

public class CGSSCardFilter {
    
    var cardFilterTypes = [CGSSCardFilterType]()
    var attributeFilterTypes = [CGSSAttributeFilterType]()
    var rarityFilterTypes = [CGSSCardRarityFilterType]()
    var favoriteFilterTypes = [CGSSFavoriteFilterType]()
    public init(cardMask: UInt, attributeMask: UInt, rarityMask: UInt, favoriteMask: UInt?) {
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
        for i: UInt in 0...1 {
            let mask = (favoriteMask ?? 0b11) >> i
            if mask % 2 == 1 {
                favoriteFilterTypes.append(CGSSFavoriteFilterType.init(rawValue: 1 << i)!)
            }
        }
    }
    
    func addCardFilterType(filterType: CGSSCardFilterType) {
        self.cardFilterTypes.append(filterType)
    }
    func addCardRarityFilterType(filterType: CGSSCardRarityFilterType) {
        self.rarityFilterTypes.append(filterType)
    }
    func addAttributeFilterType(filterType: CGSSAttributeFilterType) {
        self.attributeFilterTypes.append(filterType)
    }
    func addFavoriteFilterType(filterType: CGSSFavoriteFilterType) {
        self.favoriteFilterTypes.append(filterType)
    }
    
    func removeCardFilterType(filterType: CGSSCardFilterType) {
        if let index = self.cardFilterTypes.indexOf(filterType) {
            self.cardFilterTypes.removeAtIndex(index)
        }
    }
    func removeAttributeFilterType(filterType: CGSSAttributeFilterType) {
        if let index = self.attributeFilterTypes.indexOf(filterType) {
            self.attributeFilterTypes.removeAtIndex(index)
        }
    }
    func removeCardRarityFilterType(filterType: CGSSCardRarityFilterType) {
        if let index = self.rarityFilterTypes.indexOf(filterType) {
            self.rarityFilterTypes.removeAtIndex(index)
        }
    }
    func removeFavoriteFilterType(filterType: CGSSFavoriteFilterType) {
        if let index = self.favoriteFilterTypes.indexOf(filterType) {
            self.favoriteFilterTypes.removeAtIndex(index)
        }
    }
    
    func hasCardFilterType(cardFilterType: CGSSCardFilterType) -> Bool {
        return self.cardFilterTypes.contains(cardFilterType)
    }
    func hasAttributeFilterType(attributeFilterType: CGSSAttributeFilterType) -> Bool {
        return self.attributeFilterTypes.contains(attributeFilterType)
    }
    func hasCardRarityFilterType(cardRarityFilterType: CGSSCardRarityFilterType) -> Bool {
        return self.rarityFilterTypes.contains(cardRarityFilterType)
    }
    func hasFavoriteFilterType(favoriteFilterType: CGSSFavoriteFilterType) -> Bool {
        return self.favoriteFilterTypes.contains(favoriteFilterType)
    }
    
    func filterCardList(cardList: [CGSSCard]) -> [CGSSCard] {
        let result = cardList.filter { (v: CGSSCard) -> Bool in
            if cardFilterTypes.contains(v.cardFilterType) && attributeFilterTypes.contains(v.attributeFilterType) && rarityFilterTypes.contains(v.rarityFilterType) && favoriteFilterTypes.contains(v.favoriteFilterType) {
                return true
            }
            return false
        }
        return result
    }
    
    func writeToFile(path: String) {
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
        
        let dict = ["cardMask": cardMask, "attributeMask": attributeMask, "rarityMask": rarityMask, "favoriteMask": favoriteMask] as NSDictionary
        dict.writeToFile(path, atomically: true)
    }
    
    static func readFromFile(path: String) -> CGSSCardFilter? {
        if let dict = NSDictionary.init(contentsOfFile: path) {
            if let cardMask = dict.objectForKey("cardMask") as? UInt, attributeMask = dict.objectForKey("attributeMask") as? UInt, rarityMask = dict.objectForKey("rarityMask") as? UInt, favoriteMask = dict.objectForKey("favoriteMask") as? UInt {
                return CGSSCardFilter.init(cardMask: cardMask, attributeMask: attributeMask, rarityMask: rarityMask, favoriteMask: favoriteMask)
            }
        }
        return nil
    }
}