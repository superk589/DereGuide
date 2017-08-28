//
//  FavoriteCharaRemote.swift
//  DereGuide
//
//  Created by zzk on 2017/7/27.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation
import CloudKit

final class FavoriteCharasRemote: Remote {
    typealias R = RemoteFavoriteChara
    typealias L = FavoriteChara
    
    static var subscriptionID: String {
        return "My Favorite Charas"
    }
    
    func fetchLatestRecords(completion: @escaping ([R], [RemoteError]) -> ()) {
        cloudKitContainer.fetchUserRecordID { userRecordID, error in
            guard let userID = userRecordID else {
                completion([], [RemoteError.init(cloudKitError: error)].flatMap { $0 })
                return
            }
            let query = CKQuery(recordType: R.recordType, predicate: self.predicateOfUser(userID))
            query.sortDescriptors = [self.defaultSortDescriptor]
            let op = CKQueryOperation(query: query)
            //        op.resultsLimit = maximumNumberOfUnits
            op.fetchAggregateResults(in: self.cloudKitContainer.publicCloudDatabase, previousResults: [], previousErrors: []) { records, errors in
                if errors.count > 0 {
                    print(errors)
                }
                let rs = records.map { R(record: $0) }.flatMap { $0 }
                completion(rs, errors.map(RemoteError.init).flatMap { $0 })
                self.remove(rs.redundants { $0.charaID == $1.charaID }.map { $0.id }, completion: { _, _ in })
            }
        }
    }
}
