//
//  CGSSSorterFilterManager.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/25.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSSorterFilterManager: NSObject {
    static let defaultManager = CGSSSorterFilterManager()
    static let cardSorterPath = NSHomeDirectory() + "/Documents/cardSorter.plist"
    static let teamCardSorterPath = NSHomeDirectory() + "/Documents/teamCardSorter.plist"
    static let cardFilterPath = NSHomeDirectory() + "/Documents/cardFilter.plist"
    static let teamCardFilterPath = NSHomeDirectory() + "/Documents/teamCardFilter.plist"
    static let charFilterPath = NSHomeDirectory() + "/Documents/charFilter.plist"
    static let charSorterPath = NSHomeDirectory() + "/Documents/charSorter.plist"
    
    lazy var cardSorter = CGSSSorter.readFromFile(cardSorterPath) ?? CGSSSorter.init(att: "update_id")
    lazy var teamCardSorter = CGSSSorter.readFromFile(teamCardSorterPath) ?? CGSSSorter.init(att: "update_id")
    lazy var cardfilter = CGSSCardFilter.readFromFile(cardFilterPath) ?? CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b11110000, favoriteMask: nil)
    lazy var teamCardfilter = CGSSCardFilter.readFromFile(teamCardFilterPath) ?? CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b10100000, favoriteMask: nil)
    lazy var charFilter = CGSSCharFilter.readFromFile(charFilterPath) ?? CGSSCharFilter.init(typeMask: 0b111, ageMask: 0b11111, bloodMask: 0b11111, cvMask: 0b11)
    lazy var charSorter = CGSSSorter.readFromFile(charSorterPath) ?? CGSSSorter.init(att: "sName", ascending: true)
    
    func saveForTeam() {
        teamCardSorter.writeToFile(CGSSSorterFilterManager.teamCardSorterPath)
        teamCardfilter.writeToFile(CGSSSorterFilterManager.teamCardFilterPath)
    }
    
    func saveForCard() {
        cardSorter.writeToFile(CGSSSorterFilterManager.cardSorterPath)
        cardfilter.writeToFile(CGSSSorterFilterManager.cardFilterPath)
    }
    func saveForChar() {
        charFilter.writeToFile(CGSSSorterFilterManager.charFilterPath)
        charSorter.writeToFile(CGSSSorterFilterManager.charSorterPath)
    }
    
    private override init() {
        super.init()
    }
}
