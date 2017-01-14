//
//  CGSSSorterFilterManager.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/25.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSSorterFilterManager {
    static let `default` = CGSSSorterFilterManager()
    
    struct SorterPath {
        static let card = NSHomeDirectory() + "/Documents/cardSorter.plist"
        static let teamCard = NSHomeDirectory() + "/Documents/teamCardSorter.plist"
        static let song = NSHomeDirectory() + "/Documents/songSorter.plist"
        static let char = NSHomeDirectory() + "/Documents/charSorter.plist"
    }
    struct FilterPath {
        static let card = NSHomeDirectory() + "/Documents/cardFilter.plist"
        static let teamCard = NSHomeDirectory() + "/Documents/teamCardFilter.plist"
        static let song = NSHomeDirectory() + "/Documents/songFilter.plist"
        static let char = NSHomeDirectory() + "/Documents/charFilter.plist"
    }
    
    lazy var cardSorter = CGSSSorter.init(fromFile: SorterPath.card) ?? CGSSSorter.init(property: "update_id")
    
    lazy var teamCardSorter = CGSSSorter.init(fromFile: SorterPath.teamCard) ?? CGSSSorter.init(property: "update_id")
    
    lazy var cardfilter = CGSSCardFilter.init(fromFile: FilterPath.card) ?? CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b11110000, skillMask: 0b111111111, gachaMask: 0b1111, favoriteMask: nil)
    
    lazy var teamCardfilter = CGSSCardFilter.init(fromFile: FilterPath.teamCard) ?? CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b10100000, skillMask: 0b000000111, gachaMask: 0b1111, favoriteMask: nil)
    
    lazy var charFilter = CGSSCharFilter.init(fromFile: FilterPath.char) ?? CGSSCharFilter.init(typeMask: 0b111, ageMask: 0b11111, bloodMask: 0b11111, cvMask: 0b11, favoriteMask: 0b11)
    
    lazy var charSorter = CGSSSorter.init(fromFile: SorterPath.char) ?? CGSSSorter.init(property: "sName", ascending: true)
    
    lazy var songFilter = CGSSSongFilter.init(fromFile: FilterPath.song) ?? CGSSSongFilter.init(typeMask: 0b1111, eventMask: 0b1111)
    
    lazy var songSorter = CGSSSorter.init(fromFile: SorterPath.song) ?? CGSSSorter.init(property: "updateId")
    
    
    func saveForTeam() {
        teamCardSorter.save(to: SorterPath.teamCard)
        teamCardfilter.save(to: FilterPath.teamCard)
    }
    
    func saveForCard() {
        cardSorter.save(to: SorterPath.card)
        cardfilter.save(to: FilterPath.card)
    }
    func saveForChar() {
        charFilter.save(to: FilterPath.char)
        charSorter.save(to: SorterPath.char)
    }
    func saveForSong() {
        songFilter.save(to: FilterPath.song)
        songSorter.save(to: SorterPath.song)
    }
    
    fileprivate init() {
        
    }
}
