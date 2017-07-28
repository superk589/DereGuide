//
//  FavoriteCardsManager.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/28.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation
import CoreData

class FavoriteCardsManager: FavoriteManager {
    
    var favorites = [FavoriteCard]()
    
    func postChangedNotification() {
        NotificationCenter.default.post(name: .favoriteCardsChanged, object: nil)
    }
    
    var observerToken: NSObjectProtocol?
    
    typealias Favorite = FavoriteCard
    
    static let shared = FavoriteCardsManager()
    
    private init() {
        setup()
    }

    deinit {
        observerToken = nil
    }
    
    func add(_ card: CGSSCard) {
        FavoriteCard.insert(into: context, cardID: card.id)
        context.saveOrRollback()
    }

}
