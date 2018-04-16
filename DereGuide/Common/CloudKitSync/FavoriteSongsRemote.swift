//
//  FavoriteSongsRemote.swift
//  DereGuide
//
//  Created by zzk on 29/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation
import CloudKit

final class FavoriteSongsRemote: Remote {
    typealias R = RemoteFavoriteSong
    typealias L = FavoriteSong
    
    static var subscriptionID: String {
        return "My Favorite Songs"
    }
    
    func fetchLatestRecords(completion: @escaping ([R], [RemoteError]) -> ()) {
        cloudKitContainer.fetchUserRecordID { userRecordID, error in
            guard let userID = userRecordID else {
                completion([], [RemoteError.init(cloudKitError: error)].compactMap { $0 })
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
                let rs = records.map { R(record: $0) }.compactMap { $0 }
                completion(rs, errors.map(RemoteError.init).compactMap { $0 })
                self.remove(rs.redundants { $0.musicID == $1.musicID }.map { $0.id }, completion: { _, _ in })
            }
        }
    }
}
