//
//  TableViewCell.swift
//  DereGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

enum CGSSLiveDifficulty: Int, CustomStringConvertible, ColorRepresentable {
    
    case debut = 1
    case regular
    case pro
    case master
    case masterPlus
    case legacyMasterPlus = 101
    case light = 11
    case trick = 12
    
    static let all: [CGSSLiveDifficulty] = [CGSSLiveDifficulty.debut, .regular, .pro, .master, .masterPlus, .legacyMasterPlus, .light, .trick]
    
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
        case .legacyMasterPlus:
            return "LEGACY MASTER+"
        case .light:
            return "LIGHT"
        case .trick:
            return "TRICK"
        }
    }
    
    var color: UIColor {
        switch self {
        case .debut:
            return .debut
        case .regular:
            return .regular
        case .pro:
            return .pro
        case .master:
            return .master
        case .masterPlus:
            return .masterPlus
        case .legacyMasterPlus:
            return .legacyMasterPlus
        case .light:
            return .light
        case .trick:
            return .trick
        }
    }
    
    var difficultyTypes: CGSSLiveDifficultyTypes {
        return CGSSLiveDifficultyTypes.init(difficulty: self)
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
    static let legacyMasterPlus = CGSSLiveDifficultyTypes.init(rawValue: 1 << 5)
    static let light = CGSSLiveDifficultyTypes.init(rawValue: 1 << 6)
    static let trick = CGSSLiveDifficultyTypes.init(rawValue: 1 << 7)
    
    static let all = CGSSLiveDifficultyTypes.init(rawValue: 0b11111111)
    
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
        case .legacyMasterPlus:
            self = .legacyMasterPlus
        case .light:
            self = .light
        case .trick:
            self = .trick
        }
    }
}

extension CGSSLiveDetail {
    
    var difficultyTypes: CGSSLiveDifficultyTypes {
        return CGSSLiveDifficultyTypes(difficulty: difficulty)
    }
    
}

struct CGSSLiveDetail {
    
    var id: Int
    var difficulty: CGSSLiveDifficulty
    var liveID: Int
    var stars: Int
    var numberOfNotes: Int
    var rankSCondition: Int

    init?(fromJson json: JSON) {
        guard let difficulty = CGSSLiveDifficulty(rawValue: json["difficulty_type"].intValue) else { return nil }
        id = json["id"].intValue
        liveID = json["live_data_id"].intValue
        self.difficulty = difficulty
        stars = json["stars_number"].intValue
        numberOfNotes = json["live_notes_number"].intValue
        rankSCondition = json["rank_s_condition"].intValue
    }
    
}
