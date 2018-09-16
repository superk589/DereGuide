//
//  CloudKit+Sync.swift
//  DereGuide
//
//  Created by Florian on 26/05/15.
//  Copyright (c) 2015 objc.io. All rights reserved.
//

import CloudKit

enum CloudKitRecordChange {
    case created(CKRecord)
    case updated(CKRecord)
    case deleted(CKRecord.ID)
}


extension CKContainer {

    func fetchAllPendingNotifications(changeToken: CKServerChangeToken?, subcriptionID: String?, processChanges: @escaping (_ changeReasons: [CKRecord.ID: CKQueryNotification.Reason], _ error: NSError?, _ callback: @escaping (_ success: Bool) -> ()) -> ()) {
        let op = CKFetchNotificationChangesOperation(previousServerChangeToken: changeToken)
        var changeReasons: [CKRecord.ID: CKQueryNotification.Reason] = [:]
        var notificationIDs: [CKNotification.ID] = []
        
        op.notificationChangedBlock = { note in
            if note.subscriptionID == subcriptionID {
                if let notificationID = note.notificationID {
                    notificationIDs.append(notificationID)
                }
                if let n = note as? CKQueryNotification, let recordID = n.recordID {
                    changeReasons[recordID] = n.queryNotificationReason
                }
            }
        }
        op.fetchNotificationChangesCompletionBlock = { newChangeToken, error in
            processChanges(changeReasons, error as NSError?) { success in
                guard success && notificationIDs.count > 0 else { return }
                let op = CKMarkNotificationsReadOperation(notificationIDsToMarkRead: notificationIDs)
                self.add(op)
            }
            if op.moreComing {
                self.fetchAllPendingNotifications(changeToken: newChangeToken, subcriptionID: subcriptionID, processChanges: processChanges)
            }
        }
        add(op)
    }

}


extension CKDatabase {

    func fetchRecords(for changeReasons: [CKRecord.ID: CKQueryNotification.Reason], completion: @escaping ([CloudKitRecordChange], NSError?) -> ()) {
        var deletedIDs: [CKRecord.ID] = []
        var insertedOrUpdatedIDs: [CKRecord.ID] = []
        for (id, reason) in changeReasons {
            switch reason {
            case .recordDeleted: deletedIDs.append(id)
            default: insertedOrUpdatedIDs.append(id)
            }
        }
        let op = CKFetchRecordsOperation(recordIDs: insertedOrUpdatedIDs)
        op.fetchRecordsCompletionBlock = { recordsByID, error in
            var changes: [CloudKitRecordChange] = deletedIDs.map(CloudKitRecordChange.deleted)
            for (id, record) in recordsByID ?? [:] {
                guard let reason = changeReasons[id] else { continue }
                switch reason {
                case .recordCreated: changes.append(CloudKitRecordChange.created(record))
                case .recordUpdated: changes.append(CloudKitRecordChange.updated(record))
                default: fatalError("should not contain anything other than inserts and updates")
                }
            }
            completion(changes, error as NSError?)
        }
        add(op)
    }

}


extension CKQueryOperation {

    func fetchAggregateResults(in database: CKDatabase, previousResults: [CKRecord], previousErrors: [Error], completion: @escaping ([CKRecord], [Error]) -> ()) {
        var results = previousResults
        recordFetchedBlock = { record in
            results.append(record)
        }
        
        var errors = previousErrors
        queryCompletionBlock = { cursor, error in
            if let error = error {
                errors.append(error)
            }
            guard let c = cursor else { return completion(results, errors) }
            let nextOp = CKQueryOperation(cursor: c)
            nextOp.fetchAggregateResults(in: database, previousResults: results, previousErrors: errors, completion: completion)
        }
        database.add(self)
    }

}


extension NSError {

    func partiallyFailedRecords() -> [CKRecord.ID:NSError] {
        guard domain == CKErrorDomain else { return [:] }
        let errorCode = CKError.Code(rawValue: code)
        guard errorCode == .partialFailure else { return [:] }
        return userInfo[CKPartialErrorsByItemIDKey] as? [CKRecord.ID:NSError] ?? [:]
    }

    var partiallyFailedRecordIDsWithPermanentError: [CKRecord.ID] {
        var result: [CKRecord.ID] = []
        for (remoteID, partialError) in partiallyFailedRecords() {
            if partialError.permanentCloudKitError {
                result.append(remoteID)
            }
        }
        return result
    }

    var permanentCloudKitError: Bool {
        guard domain == CKErrorDomain else { return false }
        guard let errorCode = CKError.Code(rawValue: code) else { return false }
        switch errorCode {
            case .internalError: return true
            case .partialFailure: return false
            case .networkUnavailable: return false
            case .networkFailure: return false
            case .badContainer: return true
            case .serviceUnavailable: return false
            case .requestRateLimited: return false
            case .missingEntitlement: return true
            case .notAuthenticated: return false
            case .permissionFailure: return true
            case .unknownItem: return true
            case .invalidArguments: return true
            case .resultsTruncated: return false
            case .serverRecordChanged: return true
            case .serverRejectedRequest: return true
            case .assetFileNotFound: return true
            case .assetFileModified: return true
            case .incompatibleVersion: return true
            case .constraintViolation: return true
            case .operationCancelled: return false
            case .changeTokenExpired: return true
            case .batchRequestFailed: return false
            case .zoneBusy: return false
            case .badDatabase: return true
            case .quotaExceeded: return false
            case .zoneNotFound: return true
            case .limitExceeded: return true
            case .userDeletedZone: return true
            case .tooManyParticipants: return false
            case .alreadyShared: return true
            case .referenceViolation: return true
            case .managedAccountRestricted: return true
            case .participantMayNeedVerification: return true
            default:
                return false
//            case .serverResponseLost: return false
        }
    }
}

