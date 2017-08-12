//
//  ProfileRemote.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/14.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation
import CloudKit

final class ProfileRemote: Remote {
        
    typealias L = Profile
    typealias R = RemoteProfile
    
    static var subscriptionID: String {
        return "My Profile"
    }
    
    func removeAll(completion: @escaping ([RemoteIdentifier], RemoteError?) -> ()) {
        
        cloudKitContainer.fetchUserRecordID { userRecordID, error in
            guard let userID = userRecordID else {
                completion([], RemoteError(cloudKitError: error))
                return
            }
            let query = CKQuery(recordType: R.recordType, predicate: self.predicateOfUser(userID))
            let op = CKQueryOperation(query: query)
            op.fetchAggregateResults(in: self.cloudKitContainer.publicCloudDatabase, previousResults: []) { records, error in
                if error != nil {
                    print(error!)
                }
                let op = CKModifyRecordsOperation(recordsToSave:nil, recordIDsToDelete: records.map { $0.recordID })
                
                op.modifyRecordsCompletionBlock = { _, deletedRecordIDs, error in
                    completion((deletedRecordIDs ?? []).map { $0.recordName }, RemoteError(cloudKitError: error))
                }
                self.cloudKitContainer.publicCloudDatabase.add(op)
            }
        }
    
    }
}

