//
//  FavoriteManager.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/28.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation
import CoreData

/// main thread only
protocol FavoriteManager: class {

    associatedtype Favorite: NSManagedObject
    
    var context: NSManagedObjectContext { get }
    
    var favorites: [Favorite] { set get }
    
    var observerToken: NSObjectProtocol? { get set }
    
    func add() -> Favorite
    
    func remove(_ favorite: Favorite)
        
    func setup()
    
    func postChangedNotification()
    
}

extension FavoriteManager where Favorite: DelayedDeletable & RemoteDeletable {
    
    func remove(_ favorite: Favorite) {
        favorite.markForRemoteDeletion()
        context.saveOrRollback()
    }
}

extension FavoriteManager {
    
    var context: NSManagedObjectContext {
        return CoreDataStack.default.viewContext
    }
    
    func contains(_ favorite: Favorite) -> Bool {
        return favorites.contains(favorite)
    }

}

extension FavoriteManager where Favorite: Managed {
    
    func add() -> Favorite {
        return context.insertObject()
    }
    
    func setup() {
        let request = Favorite.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        context.performAndWait {
            self.favorites = try! self.context.fetch(request)
        }
        
        observerToken = context.addContextDidSaveNotificationObserver { (note) in
            self.favorites = Favorite.find(in: self.context, matching: Favorite.defaultPredicate)
            self.postChangedNotification()
        }
    
    }

}

extension FavoriteManager where Favorite: IDSearchable {

    /// this method is thread safe
    func contains(_ id: Int) -> Bool {
        var result = false
        context.performAndWait {
            result = self.favorites.contains { id == $0.searchedID }
        }
        return result
    }
    
}

extension FavoriteManager where Favorite: IDSearchable & DelayedDeletable & RemoteDeletable {
    
    func remove(_ id: Int) {
        favorites.filter { $0.searchedID == id }.forEach { $0.markForRemoteDeletion() }
        context.saveOrRollback()
    }
}
