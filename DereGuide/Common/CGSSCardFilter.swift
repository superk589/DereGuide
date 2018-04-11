//
//  CGSSCardFilter.swift
//  CGSSFoundation
//
//  Created by zzk on 16/7/2.
//  Copyright © 2016 zzk. All rights reserved.
//

import Foundation


struct CGSSCardFilter: CGSSFilter {
    
    var cardTypes: CGSSCardTypes
    var attributeTypes: CGSSAttributeTypes
    var rarityTypes: CGSSRarityTypes
    var skillTypes: CGSSSkillTypes
    var gachaTypes: CGSSAvailableTypes
    var conditionTypes: CGSSConditionTypes
    var procTypes: CGSSProcTypes
    var favoriteTypes: CGSSFavoriteTypes
    
    var searchText: String = ""
    
    init(cardMask: UInt, attributeMask: UInt, rarityMask: UInt, skillMask: UInt, gachaMask:UInt, conditionMask: UInt, procMask: UInt, favoriteMask: UInt?) {
        cardTypes = CGSSCardTypes.init(rawValue: cardMask)
        attributeTypes = CGSSAttributeTypes.init(rawValue: attributeMask)
        rarityTypes = CGSSRarityTypes.init(rawValue: rarityMask)
        skillTypes = CGSSSkillTypes.init(rawValue: skillMask)
        gachaTypes = CGSSAvailableTypes.init(rawValue: gachaMask)
        conditionTypes = CGSSConditionTypes.init(rawValue: conditionMask)
        procTypes = CGSSProcTypes.init(rawValue: procMask)
        favoriteTypes = CGSSFavoriteTypes.init(rawValue: favoriteMask ?? 0b11)
    }
    
    func filter(_ list: [CGSSCard]) -> [CGSSCard] {
        // let date1 = Date()
        let result = list.filter { (v: CGSSCard) -> Bool in
            let r1: Bool = searchText == "" ? true : {
                let comps = searchText.components(separatedBy: " ")
                for comp in comps {
                    if comp == "" { continue }
                    let b1 = v.name?.lowercased().contains(comp.lowercased()) ?? false
                    let b2 = v.chara?.conventional?.lowercased().contains(comp.lowercased()) ?? false
                    if b1 || b2 {
                        continue
                    } else {
                        return false
                    }
                }
                return true
            }()
            
            let r2: Bool = {
                var b1 = false
                if cardTypes == .all {
                    b1 = true
                } else {
                    if cardTypes.contains(v.cardType) {
                        b1 = true
                    }
                }
    
                var b2 = false
                if rarityTypes == .all {
                    b2 = true
                } else {
                    if rarityTypes.contains(v.rarityType) {
                        b2 = true
                    }
                }

                var b3 = false
                if attributeTypes == .all {
                    b3 = true
                } else {
                    if attributeTypes.contains(v.attributeType) {
                        b3 = true
                    }
                }

                
                var b4 = false
                if skillTypes == .all {
                    b4 = true
                } else {
                    if skillTypes.contains(v.skillType) {
                        b4 = true
                    }
                }

                var b5 = false
                if conditionTypes == .all {
                    b5 = true
                } else {
                    if conditionTypes.contains(v.skill?.conditionType ?? .other) {
                        b5 = true
                    }
                }

                
                var b6 = false
                if procTypes == .all {
                    b6 = true
                } else {
                    if procTypes.contains(v.skill?.procType ?? .none) {
                        b6 = true
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

                var b8 = false
                if gachaTypes == .all {
                    b8 = true
                } else {
                    if gachaTypes.contains(v.gachaType) {
                        b8 = true
                    }
                }
                
                if b1 && b2 && b3 && b4 && b5 && b6 && b7 && b8 {
                    return true
                }
                return false
            }()
            
            return r1 && r2
        }
        // let date2 = Date()
        // print(date2.timeIntervalSince(date1))
        return result
    }
    
    
    func toDictionary() -> NSDictionary {
        let dict = ["cardMask":cardTypes.rawValue, "attributeMask":attributeTypes.rawValue, "rarityMask":rarityTypes.rawValue, "favoriteMask":favoriteTypes.rawValue, "skillMask":skillTypes.rawValue, "conditionMask": conditionTypes.rawValue, "procMask": procTypes.rawValue, "gachaMask": gachaTypes.rawValue] as NSDictionary
        return dict
    }
    
    func save(to path: String) {
        toDictionary().write(toFile: path, atomically: true)
    }
    
    init?(fromFile path: String) {
        if let dict = NSDictionary.init(contentsOfFile: path) {
            if let cardMask = dict.object(forKey: "cardMask") as? UInt, let attributeMask = dict.object(forKey: "attributeMask") as? UInt, let rarityMask = dict.object(forKey: "rarityMask") as? UInt, let favoriteMask = dict.object(forKey: "favoriteMask") as? UInt, let skillMask = dict.object(forKey: "skillMask") as? UInt, let conditionMask = dict.object(forKey: "conditionMask") as? UInt, let procMask = dict.object(forKey: "procMask") as? UInt, let gachaMask = dict.object(forKey: "gachaMask") as? UInt {
                self.init(cardMask: cardMask, attributeMask: attributeMask, rarityMask: rarityMask,skillMask: skillMask, gachaMask: gachaMask, conditionMask: conditionMask, procMask: procMask, favoriteMask: favoriteMask)
                return
            }
        }
        return nil
    }
}
