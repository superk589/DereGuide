//
//  Potential.swift
//  DereGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation

let potentialOfLevel: [CGSSRarityTypes: [Int]] = [
    .n : [0, 80, 160, 250, 340, 440, 540, 650, 760, 880, 1000],
    .r : [0, 60, 120, 180, 255, 330, 405, 480, 570, 660, 750],
    .sr : [0, 60, 120, 180, 250, 320, 390, 460, 540, 620, 700],
    .ssr : [0, 40, 80, 120, 170, 220, 270, 320, 380, 440, 500]
]

let lifePotentialOfLevel: [CGSSRarityTypes: [Int]] = [
    .n : [0, 1, 2, 3, 4, 5, 6, 7, 9, 11, 13],
    .r : [0, 1, 2, 3, 4, 5, 6, 8, 10, 12, 14],
    .sr : [0, 1, 2, 4, 6, 8, 10, 12, 14, 17, 20],
    .ssr : [0, 1, 2, 4, 6, 8, 10, 13, 16, 19, 22]
]

let skillPotentialOfLevel: [CGSSRarityTypes: [Int]] = [
    .n : [0, 1, 2, 3, 4, 6, 8, 10, 13, 16, 20],
    .r : [0, 1, 2, 3, 4, 6, 8, 10, 13, 16, 20],
    .sr : [0, 1, 2, 3, 4, 6, 8, 10, 13, 16, 20],
    .ssr : [0, 1, 2, 3, 4, 6, 8, 10, 13, 16, 20]
]

extension CGSSRarityTypes {
    var baseRarity: CGSSRarityTypes {
        switch self {
        case CGSSRarityTypes.np, CGSSRarityTypes.n:
            return .n
        case CGSSRarityTypes.rp, CGSSRarityTypes.r:
            return .r
        case CGSSRarityTypes.srp, CGSSRarityTypes.sr:
            return .sr
        case CGSSRarityTypes.ssrp, CGSSRarityTypes.ssr:
            return .ssr
        default:
            return .n
        }
    }
}

struct Potential: Equatable {
    
    var vocal: Int
    var dance: Int
    var visual: Int
    var skill: Int
    var life: Int
    
    static let zero = Potential(vocal: 0, dance: 0, visual: 0, skill: 0, life: 0)
    
    func toAppeal(of rarity: CGSSRarityTypes) -> CGSSAppeal {
        
        let baseRarity = rarity.baseRarity
        
        return CGSSAppeal(visual: potentialOfLevel[baseRarity]![visual], vocal: potentialOfLevel[baseRarity]![vocal], dance: potentialOfLevel[baseRarity]![dance], life: lifePotentialOfLevel[baseRarity]![life])
    }
    
    var totalLevel: Int {
        return vocal + dance + visual + life + skill
    }
}
