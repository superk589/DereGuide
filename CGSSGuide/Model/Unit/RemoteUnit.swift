//
//  RemoteUnit.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/13.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

struct RemoteUnit: RemoteRecord {

    var id: String
    var creatorID: String
    
//    var center: CKReference
    var customAppeal: Int64
//    var guest: CKReference
//    var otherMembers: [CKReference]
    var supportAppeal: Int64
    var usesCustomAppeal: Int64
    var localCreatedAt: Date
    var localModifiedAt: Date
}

extension RemoteUnit {
    
    static var recordType: String { return "Unit" }
    
    init?(record: CKRecord) {
        guard record.recordType == RemoteUnit.recordType else { return nil }
        guard
//        let center = record.object(forKey: "center") as? CKReference,
        let customAppeal = record.object(forKey: "customAppeal") as? NSNumber,
//        let guest = record.object(forKey: "guest") as? CKReference,
//        let otherMembers = record["otherMembers"] as? [CKReference],
        let supportAppeal = record["supportAppeal"] as? NSNumber,
        let usesCustomAppeal = record["usesCustomAppeal"] as? NSNumber,
        let localCreatedAt = record["localCreatedAt"] as? Date,
        let localModifiedAt = record["localModifiedAt"] as? Date,
        let creatorID = record.creatorUserRecordID?.recordName else {
            return nil
        }
      
        self.id = record.recordID.recordName
        self.creatorID = creatorID
        self.localCreatedAt = localCreatedAt
//        self.center = center
//        self.guest = guest
//        self.otherMembers = otherMembers
        self.supportAppeal = supportAppeal.int64Value
        self.customAppeal = customAppeal.int64Value
        self.usesCustomAppeal = usesCustomAppeal.int64Value
        self.localModifiedAt = localModifiedAt
    }
    
}

extension RemoteUnit {
    
    func insert(into context: NSManagedObjectContext, completion: @escaping (Bool) -> ()) {
        let recordToMatch = CKReference(recordID: CKRecordID(recordName: id), action: .deleteSelf)
        let predicate = NSPredicate(format: "participatedUnit = %@", recordToMatch)
        SyncCoordinator.shared.membersRemote.fetchRecordsForCurrentUserWith([predicate], [NSSortDescriptor.init(key: "participatedPosition", ascending: true)], completion: { (remoteMembers) in
            guard remoteMembers.count == 6 else {
//                SyncCoordinator.shared.unitsRemote.remove([self.id], completion: { _, _ in
//                    // no check
//                })
                // this situation may occur when the remote unit exists, but members are still uploading, so completion(false) and let the context to retry later
                completion(false)
                return
            }
            context.perform {
                let unit = Unit.insert(into: context, customAppeal: Int(self.customAppeal), supportAppeal: Int(self.supportAppeal), usesCustomAppeal: self.usesCustomAppeal == 0 ? false : true, members: remoteMembers.map { $0.insert(into: context) })
                unit.creatorID = self.creatorID
                unit.remoteIdentifier = self.id
                completion(true)
            }
        })
    }
    
}
