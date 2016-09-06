//
//  CGSSFavoriteManager.swift
//  CGSSFoundation
//
//  Created by zzk on 16/7/9.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

public class CGSSFavoriteManager: NSObject {
    public static let defaultManager = CGSSFavoriteManager()
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
    
    private override init() {
        super.init()
    }
    
    func writeFavoriteCardsToFile() {
        (favoriteCards as NSArray).writeToFile(CGSSFavoriteManager.favoriteCardsFilePath, atomically: true)
    }
    func writeFavoriteCharsToFile() {
        (favoriteChars as NSArray).writeToFile(CGSSFavoriteManager.favoriteCharsFilePath, atomically: true)
    }
    
    func addFavoriteCard(card: CGSSCard) {
        self.favoriteCards.append(card.id!)
    }
    func removeFavoriteCard(card: CGSSCard) {
        if let index = favoriteCards.indexOf(card.id!) {
            self.favoriteCards.removeAtIndex(index)
        }
    }
    public func containsCard(cardId: Int) -> Bool {
        return favoriteCards.contains(cardId)
    }
    
    func addFavoriteChar(char: CGSSChar) {
        self.favoriteChars.append(char.charaId)
    }
    func removeFavoriteChar(char: CGSSChar) {
        if let index = favoriteChars.indexOf(char.charaId!) {
            self.favoriteChars.removeAtIndex(index)
        }
    }
    public func containsChar(charId: Int) -> Bool {
        return favoriteChars.contains(charId)
    }
}
