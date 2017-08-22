//
//  TableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

enum CGSSLiveDifficulty: Int, CustomStringConvertible, ColorRepresentable {
    case debut = 1
    case regular
    case pro
    case master
    case masterPlus
    case legacyMasterPlus
    
    static let all: [CGSSLiveDifficulty] = [CGSSLiveDifficulty.debut, .regular, .pro, .master, .masterPlus]
    
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
        }
    }
    
    var color: UIColor {
        switch self {
        case .debut:
            return Color.debut
        case .regular:
            return Color.regular
        case .pro:
            return Color.pro
        case .master:
            return Color.master
        case .masterPlus:
            return Color.masterPlus
        case .legacyMasterPlus:
            return Color.masterPlus
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
        default:
            fatalError("no matched types")
        }
    }
    
    var max: CGSSLiveDifficulty? {
        if self.contains(.masterPlus) {
            return .masterPlus
        } else if self.contains(.master) {
            return .master
        } else if self.contains(.pro) {
            return .pro
        } else if self.contains(.regular) {
            return .regular
        } else if self.contains(.debut) {
            return .debut
        } else {
            return nil
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
    var numberOfNotes: Int
        
    init(detailId: Int, difficulty: CGSSLiveDifficulty, stars: Int, numberOfNotes: Int) {
        
        self.difficulty = difficulty
        self.id = detailId
        self.stars = stars
        self.numberOfNotes = numberOfNotes
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
