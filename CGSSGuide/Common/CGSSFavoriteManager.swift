//
//  CGSSFavoriteManager.swift
//  CGSSFoundation
//
//  Created by zzk on 16/7/9.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

open class CGSSFavoriteManager: NSObject {
    open static let defaultManager = CGSSFavoriteManager()
    static let favoriteCardsFilePath = NSHomeDirectory() + "/Documents/favoriteCards.plist"
    static let favoriteCharsFilePath = NSHomeDirectory() + "/Documents/favoriteChars.plist"
    var favoriteCards: [Int] = NSArray.init(contentsOfFile: CGSSFavoriteManager.favoriteCardsFilePath) as? [Int] ?? [Int]() {
        didSet {
            writeFavoriteCardsToFile()
        }
    }
    var favoriteChars: [Int] = NSArray.init(contentsOfFile: CGSSFavoriteManager.favoriteCharsFilePath) as? [Int] ?? [Int]() {
        didSet {
            writeFavoriteCharsToFile()
        }
    }
    
    fileprivate override init() {
        super.init()
    }
    
    func writeFavoriteCardsToFile() {
        (favoriteCards as NSArray).write(toFile: CGSSFavoriteManager.favoriteCardsFilePath, atomically: true)
    }
    func writeFavoriteCharsToFile() {
        (favoriteChars as NSArray).write(toFile: CGSSFavoriteManager.favoriteCharsFilePath, atomically: true)
    }
    
    func addFavoriteCard(_ card: CGSSCard) {
        self.favoriteCards.append(card.id!)
    }
    func removeFavoriteCard(_ card: CGSSCard) {
        if let index = favoriteCards.index(of: card.id!) {
            self.favoriteCards.remove(at: index)
        }
    }
    open func containsCard(_ cardId: Int) -> Bool {
        return favoriteCards.contains(cardId)
    }
    
    func addFavoriteChar(_ char: CGSSChar) {
        self.favoriteChars.append(char.charaId)
    }
    func removeFavoriteChar(_ char: CGSSChar) {
        if let index = favoriteChars.index(of: char.charaId!) {
            self.favoriteChars.remove(at: index)
        }
    }
    open func containsChar(_ charId: Int) -> Bool {
        return favoriteChars.contains(charId)
    }
}
