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

}

extension RemoteUnit {
    
    static var recordType: String { return "Unit" }
    
    init?(record: CKRecord) {
        guard record.recordType == RemoteUnit.recordType else { fatalError("wrong record type") }
        guard
//        let center = record.object(forKey: "center") as? CKReference,
        let customAppeal = record.object(forKey: "customAppeal") as? Int64,
//        let guest = record.object(forKey: "guest") as? CKReference,
//        let otherMembers = record["otherMembers"] as? [CKReference],
        let supportAppeal = record["supportAppeal"] as? Int64,
        let usesCustomAppeal = record["usesCustomAppeal"] as? Int64,
        let localCreatedAt = record["localCreatedAt"] as? Date,
        let creatorID = record.creatorUserRecordID?.recordName else {
            return nil
        }
      
        self.id = record.recordID.recordName
        self.creatorID = creatorID
        self.localCreatedAt = localCreatedAt
//        self.center = center
//        self.guest = guest
//        self.otherMembers = otherMembers
        self.supportAppeal = supportAppeal
        self.customAppeal = customAppeal
        self.usesCustomAppeal = usesCustomAppeal
    }
    
}

extension RemoteUnit {
    
    func insert(into context: NSManagedObjectContext) {
        let recordToMatch = CKReference(recordID: CKRecordID(recordName: id), action: .none)
        let predicate = NSPredicate(format: "participatedUnit = %@", recordToMatch)
        SyncCoordinator.shared.membersRemote.fetchRecordsForCurrentUserWith([predicate], [NSSortDescriptor.init(key: "participatedPosition", ascending: true)], completion: { (remoteMembers) in
            guard remoteMembers.count == 6 else {
                return
            }
            
            let otherMembers = remoteMembers[1...4].map {
                return $0.insert(into: context)
            }
            Unit.insert(into: context, customAppeal: Int(self.customAppeal), supportAppeal: Int(self.supportAppeal), usesCustomAppeal: self.usesCustomAppeal == 0 ? false : true, center: remoteMembers[0].insert(into: context), guest: remoteMembers[5].insert(into: context), otherMembers: otherMembers)
        })
    }
    
}
