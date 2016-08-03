//
//  CGSSCardRarity.swift
//  CGSSFoundation
//
//  Created by zzk on 16/7/2.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation




public class CGSSCardRarity : NSObject{
    //    "rarity": {
    public var add_max_level:Int
    //    "add_max_level": 0,
    public var add_param:Int
    //    "add_param": 0,
    public var base_give_exp:Int
    public var base_give_money:Int
    //    "base_give_exp": 1000,
    //    "base_give_money": 5000,
    public var base_max_level:Int
    //    "base_max_level": 60,
    public var max_love:Int
    //    "max_love": 100,
    public var max_star_rank:Int
    //    "max_star_rank": 20,
    public var rarity:Int
    //    "rarity": 5
    //    ; from 1 = N to 8 = SSR+.
    //    },
    public var rarityString:String
    
    public init?(value: Int) {
        switch value {
        case 1:
            self.add_max_level = 0
            //    "add_max_level": 0,
            self.add_param = 0
            //    "add_param": 0,
            self.base_give_exp = 1000
            self.base_give_money = 200
            //    "base_give_exp": 1000,
            //    "base_give_money": 5000,
            self.base_max_level = 20
            //    "base_max_level": 20,
            self.max_love = 20
            //    "max_love": 100,
            self.max_star_rank = 5
            //    "max_star_rank": 20,
            self.rarity = 1
            self.rarityString = "N"
        case 2:
            self.add_max_level = 0
            //    "add_max_level": 0,
            self.add_param = 0
            //    "add_param": 0,
            self.base_give_exp = 1000
            self.base_give_money = 300
            //    "base_give_exp": 1000,
            //    "base_give_money": 5000,
            self.base_max_level = 30
            //    "base_max_level": 20,
            self.max_love = 50
            //    "max_love": 100,
            self.max_star_rank = 5
            //    "max_star_rank": 20,
            self.rarity = 2
            self.rarityString = "N+"
        case 3:
            self.add_max_level = 0
            //    "add_max_level": 0,
            self.add_param = 0
            //    "add_param": 0,
            self.base_give_exp = 500
            self.base_give_money = 1000
            //    "base_give_exp": 1000,
            //    "base_give_money": 5000,
            self.base_max_level = 40
            //    "base_max_level": 20,
            self.max_love = 50
            //    "max_love": 100,
            self.max_star_rank = 10
            //    "max_star_rank": 20,
            self.rarity = 3
            self.rarityString = "R"
            
        case 4:
            self.add_max_level = 0
            //    "add_max_level": 0,
            self.add_param = 0
            //    "add_param": 0,
            self.base_give_exp = 1000
            self.base_give_money = 1500
            //    "base_give_exp": 1000,
            //    "base_give_money": 5000,
            self.base_max_level = 50
            //    "base_max_level": 20,
            self.max_love = 150
            //    "max_love": 100,
            self.max_star_rank = 10
            //    "max_star_rank": 20,
            self.rarity = 4
            self.rarityString = "R+"
            
        case 5:
            self.add_max_level = 0
            //    "add_max_level": 0,
            self.add_param = 0
            //    "add_param": 0,
            self.base_give_exp = 1000
            self.base_give_money = 5000
            //    "base_give_exp": 1000,
            //    "base_give_money": 5000,
            self.base_max_level = 60
            //    "base_max_level": 20,
            self.max_love = 100
            //    "max_love": 100,
            self.max_star_rank = 15
            //    "max_star_rank": 20,
            self.rarity = 5
            self.rarityString = "SR"
            
        case 6:
            self.add_max_level = 0
            //    "add_max_level": 0,
            self.add_param = 0
            //    "add_param": 0,
            self.base_give_exp = 1000
            self.base_give_money = 7500
            //    "base_give_exp": 1000,
            //    "base_give_money": 5000,
            self.base_max_level = 70
            //    "base_max_level": 20,
            self.max_love = 300
            //    "max_love": 100,
            self.max_star_rank = 15
            //    "max_star_rank": 20,
            self.rarity = 6
            self.rarityString = "SR+"
            
        case 7:
            self.add_max_level = 0
            //    "add_max_level": 0,
            self.add_param = 0
            //    "add_param": 0,
            self.base_give_exp = 1000
            self.base_give_money = 10000
            //    "base_give_exp": 1000,
            //    "base_give_money": 5000,
            self.base_max_level = 80
            //    "base_max_level": 20,
            self.max_love = 200
            //    "max_love": 100,
            self.max_star_rank = 20
            //    "max_star_rank": 20,
            self.rarity = 7
            self.rarityString = "SSR"
        case 8:
            self.add_max_level = 0
            //    "add_max_level": 0,
            self.add_param = 0
            //    "add_param": 0,
            self.base_give_exp = 1000
            self.base_give_money = 15000
            //    "base_give_exp": 1000,
            //    "base_give_money": 5000,
            self.base_max_level = 90
            //    "base_max_level": 20,
            self.max_love = 600
            //    "max_love": 100,
            self.max_star_rank = 20
            //    "max_star_rank": 20,
            self.rarity = 8
            self.rarityString = "SSR+"
            
        default:
            self.add_max_level = 0
            //    "add_max_level": 0,
            self.add_param = 0
            //    "add_param": 0,
            self.base_give_exp = 0
            self.base_give_money = 0
            //    "base_give_exp": 1000,
            //    "base_give_money": 5000,
            self.base_max_level = 0
            //    "base_max_level": 20,
            self.max_love = 0
            //    "max_love": 100,
            self.max_star_rank = 0
            //    "max_star_rank": 20,
            self.rarity = 0
            self.rarityString = ""
            
        }
  
    }
}

