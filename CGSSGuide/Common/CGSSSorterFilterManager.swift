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
        static let live = NSHomeDirectory() + "/Documents/liveSorter.plist"
        static let char = NSHomeDirectory() + "/Documents/charSorter.plist"
        static let event = NSHomeDirectory() + "/Documents/eventSorter.plist"
        static let gachaPool = NSHomeDirectory() + "/Documents/gachaPoolSorter.plist"
    }
    struct FilterPath {
        static let card = NSHomeDirectory() + "/Documents/cardFilter.plist"
        static let teamCard = NSHomeDirectory() + "/Documents/teamCardFilter.plist"
        static let live = NSHomeDirectory() + "/Documents/liveFilter.plist"
        static let char = NSHomeDirectory() + "/Documents/charFilter.plist"
        static let event = NSHomeDirectory() + "/Documents/eventFilter.plist"
        static let gachaPool = NSHomeDirectory() + "/Documents/gachaPoolFilter.plist"
    }
    
    struct DefaultFilter {
        static let card = CGSSCardFilter.init(cardMask: 0b111, attributeMask: 0b111, rarityMask: 0b11110000, skillMask: 0b111_1111_1111_1111, gachaMask: 0b11111, conditionMask: 0b1111111, procMask: 0b1111, favoriteMask: nil)
        static let teamCard = CGSSCardFilter.init(cardMask: 0b111, attributeMask: 0b111, rarityMask: 0b10100000, skillMask: 0b011_1111_1000_0111, gachaMask: 0b11111, conditionMask: 0b1111111, procMask: 0b1111,  favoriteMask: nil)
        static let char = CGSSCharFilter.init(typeMask: 0b111, ageMask: 0b11111, bloodMask: 0b11111, cvMask: 0b11, favoriteMask: 0b11)
        static let live = CGSSLiveFilter.init(typeMask: 0b1111, eventMask: 0b1111)
        static let event = CGSSEventFilter.init(typeMask: 0b11111)
        static let gacha = CGSSCardFilter.init(cardMask: 0b111, attributeMask: 0b111, rarityMask: 0b11111111, skillMask: 0b111_1111_1111_1111, gachaMask: 0b11111,  conditionMask: 0b1111111, procMask: 0b1111, favoriteMask: nil)
        static let gachaPool = CGSSGachaFilter.init(typeMask: 0b1111)
    }
    
    struct DefaultSorter {
        static let card = CGSSSorter.init(property: "update_id")
        static let teamCard = CGSSSorter.init(property: "update_id")
        static let char = CGSSSorter.init(property: "sName", ascending: true)
        static let live = CGSSSorter.init(property: "updateId")
        static let event = CGSSSorter.init(property: "sortId")
        static let gacha = CGSSSorter.init(property: "sRarity")
        static let gachaPool = CGSSSorter.init(property: "id")
    }
    
    lazy var cardSorter = CGSSSorter.init(fromFile: SorterPath.card) ?? DefaultSorter.card
    
    lazy var teamCardSorter = CGSSSorter.init(fromFile: SorterPath.teamCard) ?? DefaultSorter.teamCard
    
    lazy var cardfilter = CGSSCardFilter.init(fromFile: FilterPath.card) ?? DefaultFilter.card

    lazy var teamCardfilter = CGSSCardFilter.init(fromFile: FilterPath.teamCard) ?? DefaultFilter.teamCard
    
    lazy var charFilter = CGSSCharFilter.init(fromFile: FilterPath.char) ?? DefaultFilter.char
    
    lazy var charSorter = CGSSSorter.init(fromFile: SorterPath.char) ?? DefaultSorter.char
    
    lazy var liveFilter = CGSSLiveFilter.init(fromFile: FilterPath.live) ?? DefaultFilter.live
    
    lazy var liveSorter = CGSSSorter.init(fromFile: SorterPath.live) ?? DefaultSorter.live
    
    lazy var eventFilter = CGSSEventFilter.init(fromFile: FilterPath.event) ?? DefaultFilter.event
    
    lazy var eventSorter = CGSSSorter.init(fromFile: SorterPath.event) ?? DefaultSorter.event
    
    lazy var gachaPoolFilter = CGSSGachaFilter.init(fromFile: FilterPath.gachaPool) ?? DefaultFilter.gachaPool
    
    lazy var gachaPoolSorter = CGSSSorter.init(fromFile: SorterPath.gachaPool) ?? DefaultSorter.gachaPool
    
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
    
    fileprivate init() {
        
    }
}
