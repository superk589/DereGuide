//
//  DelayedDeletable.swift
//  DereGuide
//
//  Created by Daniel Eggert on 23/08/2015.
//  Copyright © 2015 objc.io. All rights reserved.
//

import CoreData

private let MarkedForDeletionDateKey = "markedForDeletionDate"

public protocol DelayedDeletable: class {
    var changedForDelayedDeletion: Bool { get }
    var markedForDeletionDate: Date? { get set }
    func markForLocalDeletion()
}

extension DelayedDeletable {
    public static var notMarkedForLocalDeletionPredicate: NSPredicate {
        return NSPredicate(format: "%K == NULL", MarkedForDeletionDateKey)
    }
}

extension DelayedDeletable where Self: NSManagedObject {
    public var changedForDelayedDeletion: Bool {
        return changedValue(forKey: MarkedForDeletionDateKey) as? Date != nil
    }

    /// Mark an object to be deleted at a later point in time.
    /// An object marked for local deletion will no longer match the
    /// `notMarkedForDeletionPredicate`.
    public func markForLocalDeletion() {
        guard isFault || markedForDeletionDate == nil else { return }
        markedForDeletionDate = Date()
    }
    
}

/// Objects that have been marked for local deletion more than this time (in seconds) ago will get permanently deleted.
private let DeletionAgeBeforePermanentlyDeletingObjects = TimeInterval(2 * 60)

extension NSManagedObjectContext {
    
//    public func batchDeleteObjectsMarkedForLocalDeletion() {
//        Unit.batchDeleteObjectsMarkedForLocalDeletionInContext(self)
//        FavoriteCard.batchDeleteObjectsMarkedForLocalDeletionInContext(self)
//        FavoriteChara.batchDeleteObjectsMarkedForLocalDeletionInContext(self)
//    }
    
    public func deleteObjectsMarkedForLocalDeletion() {
        Unit.deleteObjectsMarkedForLocalDeletionInContext(self)
        FavoriteCard.deleteObjectsMarkedForLocalDeletionInContext(self)
        FavoriteChara.deleteObjectsMarkedForLocalDeletionInContext(self)
        FavoriteSong.deleteObjectsMarkedForLocalDeletionInContext(self)
        saveOrRollback()
    }
    
}

extension DelayedDeletable where Self: NSManagedObject, Self: Managed {
    
//    fileprivate static func batchDeleteObjectsMarkedForLocalDeletionInContext(_ managedObjectContext: NSManagedObjectContext) {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
//        let cutoff = Date(timeIntervalSinceNow: -DeletionAgeBeforePermanentlyDeletingObjects)
//        fetchRequest.predicate = NSPredicate(format: "%K < %@", MarkedForDeletionDateKey, cutoff as NSDate)
//        let batchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        batchRequest.resultType = .resultTypeObjectIDs
//        guard let result = try! managedObjectContext.execute(batchRequest) as? NSBatchDeleteResult else {
//            fatalError("Wrong result type")
//        }
//        guard let objectIDs = result.result as? [NSManagedObjectID]
//            else { fatalError("Expected object IDs") }
//        let changes = [NSDeletedObjectsKey: objectIDs]
//        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes,
//            into: [managedObjectContext])
//        // TODO: here we also need to tell other context these changes
//    }

    fileprivate static func deleteObjectsMarkedForLocalDeletionInContext(_ managedObjectContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<Self>(entityName: self.entityName)
        let cutoff = Date(timeIntervalSinceNow: -DeletionAgeBeforePermanentlyDeletingObjects)
        fetchRequest.predicate = NSPredicate(format: "%K < %@", MarkedForDeletionDateKey, cutoff as NSDate)
        let objects = try! managedObjectContext.fetch(fetchRequest)
        if objects.count > 0 {
            print("delete \(objects.count) \(self.entityName)\(objects.count > 1 ? "s" : "") locally")
        }
        objects.forEach { managedObjectContext.delete($0) }
    }

}
