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
    
    func removeAll(completion: @escaping ([RemoteIdentifier], [RemoteError]) -> ()) {
        
        cloudKitContainer.fetchUserRecordID { userRecordID, error in
            guard let userID = userRecordID else {
                
                completion([], [RemoteError.init(cloudKitError: error)].flatMap { $0 })
                return
            }
            let query = CKQuery(recordType: R.recordType, predicate: self.predicateOfUser(userID))
            let op = CKQueryOperation(query: query)
            op.fetchAggregateResults(in: self.cloudKitContainer.publicCloudDatabase, previousResults: [], previousErrors: []) { records, errors in
                if errors.count > 0 {
                    print(errors)
                }
                let op = CKModifyRecordsOperation(recordsToSave:nil, recordIDsToDelete: records.map { $0.recordID })
                
                op.modifyRecordsCompletionBlock = { _, deletedRecordIDs, error in
                    completion((deletedRecordIDs ?? []).map { $0.recordName }, [RemoteError(cloudKitError: error)].flatMap { $0 })
                }
                self.cloudKitContainer.publicCloudDatabase.add(op)
            }
        }
    
    }
}

