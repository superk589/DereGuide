//
//  FavoriteSongsManager.swift
//  DereGuide
//
//  Created by zzk on 11/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation
import CoreData

class FavoriteSongsManager: FavoriteManager {
    
    var favorites = [FavoriteSong]()
    
    func postChangedNotification() {
        NotificationCenter.default.post(name: .favoriteSongsChanged, object: nil)
    }
    
    var observerToken: NSObjectProtocol?
    
    typealias Favorite = FavoriteSong
    
    static let shared = FavoriteSongsManager()
    
    private init() {
        setup()
    }
    
    deinit {
        observerToken = nil
    }
    
    func add(_ song: CGSSSong) {
        FavoriteSong.insert(into: context, musicID: song.musicID)
        context.saveOrRollback()
    }
}
