//
//  CloudKitMergePolicy.swift
//  DereGuide
//
//  Created by zzk on 2017/7/13.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import CoreData

public class CloudKitMergePolicy: NSMergePolicy {
    public enum MergeMode {
        case remote
        case local
        
        fileprivate var mergeType: NSMergePolicyType {
            switch self {
            case .remote: return .mergeByPropertyObjectTrumpMergePolicyType
            case .local: return .mergeByPropertyStoreTrumpMergePolicyType
            }
        }
    }
    
    required public init(mode: MergeMode) {
        super.init(merge: mode.mergeType)
    }
    
    override open func resolve(optimisticLockingConflicts list: [NSMergeConflict]) throws {
        var regionsAndLatestDates: [(UpdateTimestampable, Date)] = []
        for (c, r) in list.conflictsAndObjects(of: UpdateTimestampable.self) {
            regionsAndLatestDates.append((r, c.newestUpdatedAt))
        }
        
        try super.resolve(optimisticLockingConflicts: list)
        
        for (region, date) in regionsAndLatestDates {
            region.updatedAt = date
        }
    }
    
}


extension NSMergeConflict {
    var newestUpdatedAt: Date {
        guard let o = sourceObject as? UpdateTimestampable else { fatalError("must be UpdateTimestampable") }
        let key = UpdateTimestampKey
        let zeroDate = Date(timeIntervalSince1970: 0)
        let objectDate = objectSnapshot?[key] as? Date ?? zeroDate
        let cachedDate = cachedSnapshot?[key] as? Date ?? zeroDate
        let persistedDate = persistedSnapshot?[key] as? Date ?? zeroDate
        return max(o.updatedAt as Date, max(objectDate, max(cachedDate, persistedDate)))
    }
}


extension Sequence where Iterator.Element == NSMergeConflict {
    func conflictedObjects<T>(of cls: T.Type) -> [T] {
        let objects = map { $0.sourceObject }
        return objects.compactMap { $0 as? T }
    }
    
    func conflictsAndObjects<T>(of cls: T.Type) -> [(NSMergeConflict, T)] {
        return filter { $0.sourceObject is T }.map { ($0, $0.sourceObject as! T) }
    }
}


