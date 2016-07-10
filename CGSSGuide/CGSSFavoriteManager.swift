//
//  CGSSFavoriteManager.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/9.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import CGSSFoundation

class CGSSFavoriteManager: NSObject {
    static let defaultManager = CGSSFavoriteManager()
    static let favoriteCardsFilePath = NSHomeDirectory()+"/Documents/favoriteCards.plist"
    var favoriteCards:[Int]! {
        didSet {
            writeFavoriteCardsToFile()
        }
    }
    override init() {
        super.init()
        initFavoriteCards()
    }
    func initFavoriteCards() {
        favoriteCards = NSArray.init(contentsOfFile: CGSSFavoriteManager.favoriteCardsFilePath) as? [Int] ?? [Int]()
    }
    func writeFavoriteCardsToFile() {
        (favoriteCards as NSArray).writeToFile(CGSSFavoriteManager.favoriteCardsFilePath, atomically: true)
    }
    
    func addFavoriteCard(card:CGSSCard, callBack: (String)->Void ) {
        self.favoriteCards.append(card.id!)
        callBack("收藏成功")
    }
    func removeFavoriteCard(card:CGSSCard, callBack: (String)->Void ) {
        if let index = favoriteCards.indexOf(card.id!) {
            self.favoriteCards.removeAtIndex(index)
        }
        callBack("取消收藏成功")
    }
    func contains(cardId:Int) -> Bool {
        return favoriteCards.contains(cardId)
    }
}
