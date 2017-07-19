//
//  RemoteModifiable.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import CoreData

private let MarkedForRemoteModificationKey = "markedForLocalChange"

protocol RemoteModifiable: class {
    var markedForLocalChange: Bool { get set }
    func markForRemoteModification()
}

extension RemoteModifiable {
    public static var notMarkedForRemoteModificationPredicate: NSPredicate {
        return NSPredicate(format: "%K == false", MarkedForRemoteModificationKey)
    }
    
    public static var markedForRemoteModificationPredicate: NSPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: notMarkedForRemoteModificationPredicate)
    }
}

extension RemoteModifiable where Self: NSManagedObject {
    func markForRemoteModification() {
        guard changedValue(forKey: MarkedForRemoteModificationKey) == nil && !markedForLocalChange else { return }
        markedForLocalChange = true
    }
}
