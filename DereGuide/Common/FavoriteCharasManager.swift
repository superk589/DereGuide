//
//  FavoriteCharasManager.swift
//  DereGuide
//
//  Created by zzk on 2017/7/28.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation
import CoreData

class FavoriteCharasManager: FavoriteManager {
    
    var favorites = [FavoriteChara]()
    
    func postChangedNotification() {
        NotificationCenter.default.post(name: .favoriteCharasChanged, object: nil)
    }
    
    var observerToken: NSObjectProtocol?
    
    typealias Favorite = FavoriteChara
    
    static let shared = FavoriteCharasManager()
    
    private init() {
        setup()
    }
    
    deinit {
        observerToken = nil
    }
    
    func add(_ chara: CGSSChar) {
        FavoriteChara.insert(into: context, charaID: chara.charaId)
        context.saveOrRollback()
    }
}
