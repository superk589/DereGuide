//
//  CGSSPotential.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

fileprivate let potentialOfLevel: [CGSSRarityTypes:[Int]] = [
    .n : [0, 80, 160, 250, 340, 440, 540, 650, 760, 880, 1000],
    .r : [0, 60, 120, 180, 255, 330, 405, 480, 570, 660, 750],
    .sr : [0, 60, 120, 180, 250, 320, 390, 460, 540, 620, 700],
    .ssr : [0, 40, 80, 120, 170, 220, 270, 320, 380, 440, 500]
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

struct CGSSPotential {
    
    var vocalLevel: Int
    var danceLevel: Int
    var visualLevel: Int
    
    var lifeLevel: Int
    
    static let zero = CGSSPotential(vocalLevel: 0, danceLevel: 0, visualLevel: 0, lifeLevel: 0)
    
    func toAppeal(of rarity: CGSSRarityTypes) -> CGSSAppeal {
        
        let baseRarity = rarity.baseRarity
        
        return CGSSAppeal(visual: potentialOfLevel[baseRarity]![visualLevel], vocal: potentialOfLevel[baseRarity]![vocalLevel], dance: potentialOfLevel[baseRarity]![danceLevel], life: potentialOfLevel[baseRarity]![lifeLevel])
    }
}
