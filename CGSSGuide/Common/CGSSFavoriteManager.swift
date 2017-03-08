//
//  CGSSFavoriteManager.swift
//  CGSSFoundation
//
//  Created by zzk on 16/7/9.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

class CGSSFavoriteManager {
    
    static let `default` = CGSSFavoriteManager()
    
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
    
    private init() {
        
    }
    
    private func writeFavoriteCardsToFile() {
        (favoriteCards as NSArray).write(toFile: CGSSFavoriteManager.favoriteCardsFilePath, atomically: true)
    }
    private func writeFavoriteCharsToFile() {
        (favoriteChars as NSArray).write(toFile: CGSSFavoriteManager.favoriteCharsFilePath, atomically: true)
    }
    
    func add(_ card: CGSSCard) {
        self.favoriteCards.append(card.id!)
    }
    func remove(_ card: CGSSCard) {
        if let index = favoriteCards.index(of: card.id!) {
            self.favoriteCards.remove(at: index)
        }
    }
    func contains(cardId: Int) -> Bool {
        return favoriteCards.contains(cardId)
    }
    
    func add(_ char: CGSSChar) {
        self.favoriteChars.append(char.charaId)
    }
    func remove(_ char: CGSSChar) {
        if let index = favoriteChars.index(of: char.charaId!) {
            self.favoriteChars.remove(at: index)
        }
    }
    func contains(charId: Int) -> Bool {
        return favoriteChars.contains(charId)
    }
}
