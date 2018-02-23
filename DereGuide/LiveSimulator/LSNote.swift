//
//  LSNote.swift
//  DereGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct LSNote {

    var comboFactor: Double
    var baseScore: Double
    var sec: Float
    var rangeType: CGSSBeatmapNote.RangeType
    
    func lifeLost(in difficulty: CGSSLiveDifficulty, evaluation: LSEvaluationType) -> Int {
        return lifeLoss[evaluation]?[difficulty]?[rangeType] ?? 0
    }
    
}

enum LSEvaluationType {
    case perfect
    case great
    case good
    case bad
    case miss
    
    var modifier: Double {
        switch self {
        case .perfect:
            return 1
        case .great:
            return 0.7
        case .good:
            return 0.4
        case .bad:
            return 0.1
        case .miss:
            return 0
        }
    }
}

fileprivate let lifeLoss: [LSEvaluationType: [CGSSLiveDifficulty: [CGSSBeatmapNote.RangeType: Int]]] = [
    .bad: [
        .debut: [
            .click: 6,
        ],
        .regular: [
            .click: 7,
        ],
        .light: [
            .click: 7,
        ],
        .pro: [
            .click: 9,
            .slide: 5,
            .flick: 5
        ],
        .master: [
            .click: 12,
            .slide: 6,
            .flick: 6
        ],
        .masterPlus: [
            .click: 12,
            .slide: 6,
            .flick: 6
        ],
        .legacyMasterPlus: [
            .click: 12,
            .slide: 6,
            .flick: 6
        ],
        .trick: [
            .click: 12,
            .slide: 6,
            .flick: 6
        ]
    ],
    .miss: [
        .debut: [
            .click: 10,
        ],
        .regular: [
            .click: 12,
        ],
        .light: [
            .click: 12,
        ],
        .pro: [
            .click: 15,
            .slide: 8,
            .flick: 8
        ],
        .master: [
            .click: 20,
            .slide: 10,
            .flick: 10
        ],
        .masterPlus: [
            .click: 20,
            .slide: 10,
            .flick: 10
        ],
        .legacyMasterPlus: [
            .click: 20,
            .slide: 10,
            .flick: 10
        ],
        .trick: [
            .click: 20,
            .slide: 10,
            .flick: 10
        ]
    ]

]
