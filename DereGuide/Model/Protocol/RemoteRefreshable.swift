//
//  RemoteModifiable.swift
//  DereGuide
//
//  Created by zzk on 2017/7/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import CoreData
import CloudKit

private let MarkedForRemoteModificationKey = "markedForLocalChange"

/// can upload to refresh remote record
protocol RemoteRefreshable: class {
    var localTrackedKeys: [String] { get }
    var markedForLocalChange: Bool { get set }
    func markForRemoteModification()
}

extension RemoteRefreshable {
    public static var notMarkedForRemoteModificationPredicate: NSPredicate {
        return NSPredicate(format: "%K == false", MarkedForRemoteModificationKey)
    }
    
    public static var markedForRemoteModificationPredicate: NSPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: notMarkedForRemoteModificationPredicate)
    }
}

extension RemoteRefreshable where Self: NSManagedObject {
    
    var hasLocalTrackedChanges: Bool {
        return changedValues().keys.contains(where: {
            localTrackedKeys.contains($0)
        })
    }
    
    func markForRemoteModification() {
        guard changedValue(forKey: MarkedForRemoteModificationKey) == nil && !markedForLocalChange else { return }
        markedForLocalChange = true
    }
    
    func unmarkForRemoteModification() {
        markedForLocalChange = false
    }
    
}

extension RemoteRefreshable where Self: RemoteUploadable & RemoteDeletable & DelayedDeletable  {
   
    static var waitingForRemoteModificationPredicate: NSPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [markedForRemoteModificationPredicate, uploadedPredicate, notMarkedForDeletionPredicate])
    }

}
