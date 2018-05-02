//
//  CGSSSorterFilterManager.swift
//  DereGuide
//
//  Created by zzk on 16/8/25.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

class CGSSSorterFilterManager {
    
    static let `default` = CGSSSorterFilterManager()
    
    struct SorterPath {
        static let card = NSHomeDirectory() + "/Documents/cardSorter.plist"
        static let unitCard = NSHomeDirectory() + "/Documents/unitCardSorter.plist"
        static let live = NSHomeDirectory() + "/Documents/liveSorter.plist"
        static let unitLive = NSHomeDirectory() + "/Documents/unitLiveSorter.plist"
        static let char = NSHomeDirectory() + "/Documents/charSorter.plist"
        static let event = NSHomeDirectory() + "/Documents/eventSorter.plist"
        static let gachaPool = NSHomeDirectory() + "/Documents/gachaPoolSorter.plist"
        static let song = NSHomeDirectory() + "/Documents/songSorter.plist"
    }
    
    struct FilterPath {
        static let card = NSHomeDirectory() + "/Documents/cardFilter.plist"
        static let unitCard = NSHomeDirectory() + "/Documents/unitCardFilter.plist"
        static let live = NSHomeDirectory() + "/Documents/liveFilter.plist"
        static let unitLive = NSHomeDirectory() + "/Documents/unitLiveFilter.plist"
        static let char = NSHomeDirectory() + "/Documents/charFilter.plist"
        static let event = NSHomeDirectory() + "/Documents/eventFilter.plist"
        static let gachaPool = NSHomeDirectory() + "/Documents/gachaPoolFilter.plist"
        static let song = NSHomeDirectory() + "/Documents/songFilter.plist"
    }
    
    struct DefaultFilter {
        static let card = CGSSCardFilter(cardMask: 0b111, attributeMask: 0b111, rarityMask: 0b11110000, skillMask: 0b1111_1111_1111_1111, gachaMask: 0b11111, conditionMask: 0b1111111, procMask: 0b1111, favoriteMask: nil)
        static let unitCard = CGSSCardFilter(cardMask: 0b111, attributeMask: 0b111, rarityMask: 0b10100000, skillMask: 0b0111_1111_1000_0111, gachaMask: 0b11111, conditionMask: 0b1111111, procMask: 0b1111,  favoriteMask: nil)
        static let char = CGSSCharFilter(typeMask: 0b111, ageMask: 0b11111, bloodMask: 0b11111, cvMask: 0b11, favoriteMask: 0b11)
        static let live = CGSSLiveFilter(typeMask: 0b1111, eventMask: 0b1111, difficultyMask: 0b11111111)
        static let event = CGSSEventFilter(typeMask: 0b111111)
        static let gacha = CGSSCardFilter(cardMask: 0b111, attributeMask: 0b111, rarityMask: 0b11111111, skillMask: 0b1111_1111_1111_1111, gachaMask: 0b11111,  conditionMask: 0b1111111, procMask: 0b1111, favoriteMask: nil)
        static let gachaPool = CGSSGachaFilter(typeMask: 0b111111)
        static let song = CGSSSongFilter(liveMask: 0b1111, eventMask: 0b1111, centerMask: 0b1111, positionNumMask: 0b111111, favoriteMask: 0b11)
    }
    
    struct DefaultSorter {
        static let card = CGSSSorter(property: "update_id")
        static let unitCard = CGSSSorter(property: "update_id")
        static let char = CGSSSorter(property: "sName", ascending: true)
        static let live = CGSSSorter(property: "updateId")
        static let event = CGSSSorter(property: "sortId")
        static let gacha = CGSSSorter(property: "sRarity")
        static let gachaPool = CGSSSorter(property: "startDate")
        static let song = CGSSSorter(property: "_startDate")
    }
    
    var cardSorter = CGSSSorter(fromFile: SorterPath.card) ?? DefaultSorter.card
    
    var unitCardSorter = CGSSSorter(fromFile: SorterPath.unitCard) ?? DefaultSorter.unitCard
    
    var cardfilter = CGSSCardFilter(fromFile: FilterPath.card) ?? DefaultFilter.card

    var unitCardfilter = CGSSCardFilter(fromFile: FilterPath.unitCard) ?? DefaultFilter.unitCard
    
    var charFilter = CGSSCharFilter(fromFile: FilterPath.char) ?? DefaultFilter.char
    
    var charSorter = CGSSSorter(fromFile: SorterPath.char) ?? DefaultSorter.char
    
    var liveFilter = CGSSLiveFilter(fromFile: FilterPath.live) ?? DefaultFilter.live
    
    var liveSorter = CGSSSorter(fromFile: SorterPath.live) ?? DefaultSorter.live
    
    var unitLiveFilter = CGSSLiveFilter(fromFile: FilterPath.unitLive) ?? DefaultFilter.live
    
    var unitLiveSorter = CGSSSorter(fromFile: SorterPath.unitLive) ?? DefaultSorter.live
    
    var eventFilter = CGSSEventFilter(fromFile: FilterPath.event) ?? DefaultFilter.event
    
    var eventSorter = CGSSSorter(fromFile: SorterPath.event) ?? DefaultSorter.event
    
    var gachaPoolFilter = CGSSGachaFilter(fromFile: FilterPath.gachaPool) ?? DefaultFilter.gachaPool
    
    var gachaPoolSorter = CGSSSorter(fromFile: SorterPath.gachaPool) ?? DefaultSorter.gachaPool
    
    var songFilter = CGSSSongFilter(fromFile: FilterPath.song) ?? DefaultFilter.song
    
    var songSorter = CGSSSorter(fromFile: SorterPath.song) ?? DefaultSorter.song
    
    func saveForUnitCard() {
        unitCardSorter.save(to: SorterPath.unitCard)
        unitCardfilter.save(to: FilterPath.unitCard)
    }
    
    func saveForUnitLive() {
        unitLiveFilter.save(to: FilterPath.unitLive)
        unitLiveSorter.save(to: SorterPath.unitLive)
    }
    
    func saveForCard() {
        cardSorter.save(to: SorterPath.card)
        cardfilter.save(to: FilterPath.card)
    }
    
    func saveForChar() {
        charFilter.save(to: FilterPath.char)
        charSorter.save(to: SorterPath.char)
    }
    
    func saveForLive() {
        liveFilter.save(to: FilterPath.live)
        liveSorter.save(to: SorterPath.live)
    }
    
    func saveForEvent() {
        eventFilter.save(to: FilterPath.event)
        eventSorter.save(to: SorterPath.event)
    }
    
    func saveForGachaPool() {
        gachaPoolFilter.save(to: FilterPath.gachaPool)
        gachaPoolSorter.save(to: SorterPath.gachaPool)
    }
    
    func saveForSong() {
        songFilter.save(to: FilterPath.song)
        songSorter.save(to: SorterPath.song)
    }
    
    private init() {
        
    }
}
