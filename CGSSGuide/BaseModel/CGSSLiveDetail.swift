//
//  TableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

enum CGSSLiveDifficulty: Int, CustomStringConvertible {
    case debut = 1
    case regular
    case pro
    case master
    case masterPlus
    
    var description: String {
        
        switch self {
        case .debut:
            return "DEBUT"
        case .regular:
            return "REGULAR"
        case .pro:
            return "PRO"
        case .master:
            return "MASTER"
        case .masterPlus:
            return "MASTER+"
        }
    }
}

struct CGSSLiveDifficultyTypes: OptionSet {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    
    static let debut = CGSSLiveDifficultyTypes.init(rawValue: 1 << 0)
    static let regular = CGSSLiveDifficultyTypes.init(rawValue: 1 << 1)
    static let pro = CGSSLiveDifficultyTypes.init(rawValue: 1 << 2)
    static let master = CGSSLiveDifficultyTypes.init(rawValue: 1 << 3)
    static let masterPlus = CGSSLiveDifficultyTypes.init(rawValue: 1 << 4)

    static let all = CGSSLiveDifficultyTypes.init(rawValue: 0b11111)
    
    init(difficulty: CGSSLiveDifficulty) {
        switch difficulty {
        case .debut:
            self = .debut
        case .regular:
            self = .regular
        case .pro:
            self = .pro
        case .master:
            self = .master
        case .masterPlus:
            self = .masterPlus
        }
    }
}

extension CGSSLiveDetail {
    var difficultyTypes: CGSSLiveDifficultyTypes {
        return CGSSLiveDifficultyTypes(difficulty: difficulty)
    }
}

class CGSSLiveDetail: CGSSBaseModel {
    
    var difficulty: CGSSLiveDifficulty
    var id: Int
    var stars: Int
    var liveId: Int
    
    lazy var beatmap: CGSSBeatmap? = {
        guard let beatmaps = CGSSGameResource.shared.getBeatmaps(liveId: self.liveId) else {
            return nil
        }
        return beatmaps[self.difficulty.rawValue - 1]
    }()
    
    init(liveId: Int, detailId: Int, difficulty: CGSSLiveDifficulty, stars: Int) {
        
        self.difficulty = difficulty
        self.id = detailId
        self.liveId = liveId
        self.stars = stars
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
