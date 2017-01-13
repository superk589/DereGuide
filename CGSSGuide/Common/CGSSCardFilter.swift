//
//  CGSSCardFilter.swift
//  CGSSFoundation
//
//  Created by zzk on 16/7/2.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation


struct CGSSCardFilter {
    
    var cardTypes: CGSSCardTypes
    var attributeTypes: CGSSAttributeTypes
    var rarityTypes: CGSSRarityTypes
    var skillTypes: CGSSSkillTypes
    var gachaTypes: CGSSAvailableTypes
    var favoriteTypes: CGSSFavoriteTypes
    init(cardMask: UInt, attributeMask: UInt, rarityMask: UInt, skillMask: UInt, gachaMask:UInt, favoriteMask: UInt?) {
        cardTypes = CGSSCardTypes.init(rawValue: cardMask)
        attributeTypes = CGSSAttributeTypes.init(rawValue: attributeMask)
        rarityTypes = CGSSRarityTypes.init(rawValue: rarityMask)
        skillTypes = CGSSSkillTypes.init(rawValue: skillMask)
        gachaTypes = CGSSAvailableTypes.init(rawValue: gachaMask)
        favoriteTypes = CGSSFavoriteTypes.init(rawValue: favoriteMask ?? 0b11)
    }
  
    
    func filterCardList(_ cardList: [CGSSCard]) -> [CGSSCard] {
        let result = cardList.filter { (v: CGSSCard) -> Bool in
            if cardTypes.contains(v.cardType) && attributeTypes.contains(v.attributeType) && rarityTypes.contains(v.rarityType) && favoriteTypes.contains(v.favoriteType) && skillTypes.contains(v.skillType) /*&& gachaTypes.contains(v.gachaType)*/ {
                return true
            }
            return false
        }
        return result
    }
    
    func writeToFile(_ path: String) {
        let dict = ["cardMask":cardTypes.rawValue, "attributeMask":attributeTypes.rawValue, "rarityMask":rarityTypes.rawValue, "favoriteMask":favoriteTypes.rawValue, "skillMask":skillTypes.rawValue, "gachaMask": gachaTypes.rawValue] as NSDictionary
        dict.write(toFile: path, atomically: true)
    }
    
    static func readFromFile(_ path: String) -> CGSSCardFilter? {
        if let dict = NSDictionary.init(contentsOfFile: path) {
            if let cardMask = dict.object(forKey: "cardMask") as? UInt, let attributeMask = dict.object(forKey: "attributeMask") as? UInt, let rarityMask = dict.object(forKey: "rarityMask") as? UInt, let favoriteMask = dict.object(forKey: "favoriteMask") as? UInt, let skillMask = dict.object(forKey: "skillMask") as? UInt, let gachaMask = dict.object(forKey: "gachaMask") as? UInt{
                return CGSSCardFilter.init(cardMask: cardMask, attributeMask: attributeMask, rarityMask: rarityMask,skillMask: skillMask, gachaMask: gachaMask, favoriteMask: favoriteMask)
            }
        }
        return nil
    }
}
