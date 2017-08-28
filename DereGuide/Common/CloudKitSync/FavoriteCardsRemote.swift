//
//  FavoriteCardRemote.swift
//  DereGuide
//
//  Created by zzk on 2017/7/27.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation
import CloudKit

final class FavoriteCardsRemote: Remote {
    
    typealias R = RemoteFavoriteCard
    typealias L = FavoriteCard
    
    static var subscriptionID: String {
        return "My Favorite Cards"
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
                
                // remove redundants in remote, when user create favorites from multiple devices, the remote may have more than one of the same cardID. remove them when fetch latest records 
                self.remove(rs.redundants { $0.cardID == $1.cardID }.map { $0.id }, completion: { _, _ in })
            }
        }
    }
    
}

extension Sequence {
    
    /// find redundant elements in a sequence
    func redundants(condition: @escaping (Iterator.Element, Iterator.Element) -> Bool) -> Array<Iterator.Element> {
        var filtered = Array<Iterator.Element>()
        var result = Array<Iterator.Element>()
        for x in self {
            if filtered.contains(where: {
                return condition($0, x)
            }) {
                result.append(x)
            } else {
                filtered.append(x)
            }
        }
        return result
    }
    
}
