//
//  RemoteObject.swift
//  CGSSGuide
//
//  Created by Florian on 05/09/15.
//  Copyright © 2015 objc.io. All rights reserved.
//

import CoreData
import CoreLocation
import CloudKit

public protocol RemoteUploadable: class {
    func toCKRecord() -> CKRecord
}

public typealias RemoteIdentifier = String

public protocol RemoteRecord {
    var id: RemoteIdentifier { get set }
    var creatorID: RemoteIdentifier { get set }
    init?(record: CKRecord)
}

internal let RemoteIdentifierKey = "remoteIdentifier"

extension RemoteUploadable {

    public static func predicateForRemoteIdentifiers(_ ids: [RemoteIdentifier]) -> NSPredicate {
        return NSPredicate(format: "%K in %@", RemoteIdentifierKey, ids)
    }

}

extension RemoteUploadable where Self: RemoteDeletable & DelayedDeletable {

    public static var waitingForUploadPredicate: NSPredicate {
        let notUploaded = NSPredicate(format: "%K == NULL", RemoteIdentifierKey)
        return NSCompoundPredicate(andPredicateWithSubpredicates:[notUploaded, notMarkedForDeletionPredicate])
    }

}

