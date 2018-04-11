//
//  CGSSAppeal.swift
//  DereGuide
//
//  Created by zzk on 16/8/6.
//  Copyright © 2016 zzk. All rights reserved.
//

import Foundation

struct CGSSAppeal {
    var visual: Int
    var vocal: Int
    var dance: Int
    var life: Int
    static let zero = CGSSAppeal(visual: 0, vocal: 0, dance: 0, life: 0)
    
    var total: Int {
        return visual + dance + vocal
    }
    
    func toStringArray() -> [String] {
        return [String(vocal), String(dance), String(visual), String(total)]
    }
    
    func toStringArrayWithBackValue(_ backValue: Int) -> [String] {
        return [String(total + backValue), String(vocal), String(dance), String(visual)]
    }
    
    func addBy(potential: CGSSPotential, rarity: CGSSRarityTypes) -> CGSSAppeal {
        return potential.toAppeal(of: rarity) + self
    }
}

func + (a1: CGSSAppeal, a2: CGSSAppeal) -> CGSSAppeal {
    return CGSSAppeal.init(visual: a1.visual + a2.visual, vocal: a1.vocal + a2.vocal, dance: a1.dance + a2.dance, life: a1.life + a2.life)
}

func += (a1: inout CGSSAppeal, a2: CGSSAppeal) {
    a1 = a1 + a2
}
