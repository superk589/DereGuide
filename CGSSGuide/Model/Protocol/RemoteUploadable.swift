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
    static var recordType: String { get }
    var id: RemoteIdentifier { get set }
    var creatorID: RemoteIdentifier { get set }
    init?(record: CKRecord)
}

internal let RemoteIdentifierKey = "remoteIdentifier"

extension RemoteUploadable {

    public static func predicateForRemoteIdentifiers(_ ids: [RemoteIdentifier]) -> NSPredicate {
        return NSPredicate(format: "%K in %@", RemoteIdentifierKey, ids)
    }

    public static var notUploadedPredicate: NSPredicate {
        return NSPredicate(format: "%K == NULL", RemoteIdentifierKey)
    }
    
    public static var uploadedPredicate: NSPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: notUploadedPredicate)
    }
}

extension RemoteUploadable where Self: RemoteDeletable & DelayedDeletable {

    public static var waitingForUploadPredicate: NSPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates:[notUploadedPredicate, notMarkedForDeletionPredicate])
    }

}

