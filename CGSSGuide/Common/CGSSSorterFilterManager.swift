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
    static let cardfilterPath = NSHomeDirectory() + "/Documents/cardFilter.plist"
    static let teamCardfilterPath = NSHomeDirectory() + "/Documents/teamCardFilter.plist"
    
    lazy var cardSorter = CGSSSorter.readFromFile(cardSorterPath) ?? CGSSSorter.init(att: "update_id")
    lazy var teamCardSorter = CGSSSorter.readFromFile(teamCardSorterPath) ?? CGSSSorter.init(att: "update_id")
    lazy var cardfilter = CGSSCardFilter.readFromFile(cardfilterPath) ?? CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b11110000, favoriteMask: nil)
    lazy var teamCardfilter = CGSSCardFilter.readFromFile(teamCardfilterPath) ?? CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b10100000, favoriteMask: nil)
    
    func saveForTeam() {
        teamCardSorter.writeToFile(CGSSSorterFilterManager.teamCardSorterPath)
        teamCardfilter.writeToFile(CGSSSorterFilterManager.teamCardfilterPath)
    }
    
    func saveForCard() {
        cardSorter.writeToFile(CGSSSorterFilterManager.cardSorterPath)
        cardfilter.writeToFile(CGSSSorterFilterManager.cardfilterPath)
    }
    
    private override init() {
        super.init()
    }
}
