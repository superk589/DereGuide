//
//  UnitDownloader.swift
//  CGSSGuide
//
//  Created by Daniel Eggert on 22/05/2015.
//  Copyright (c) 2015 objc.io. All rights reserved.
//

import CoreData

final class UnitDownloader: ChangeProcessor {
   
    typealias Element = Unit
    
    var remote: UnitsRemote
    
    init(remote: UnitsRemote) {
        self.remote = remote
    }
    
    func setup(for context: ChangeProcessorContext) {
        remote.setupSubscription()
    }

    func processChangedLocalObjects(_ objects: [NSManagedObject], in context: ChangeProcessorContext) {
        // no-op
    }

    func processRemoteChanges<T>(_ changes: [RemoteRecordChange<T>], in context: ChangeProcessorContext, completion: () -> ()) {
        var creates: [RemoteUnit] = []
        var deletionIDs: [RemoteIdentifier] = []
        var updates: [RemoteUnit] = []
        for change in changes {
            switch change {
            case .insert(let r) where r is RemoteUnit:
                creates.append(r as! RemoteUnit)
            case .delete(let id):
                deletionIDs.append(id)
            case .update(let r) where r is RemoteUnit:
                updates.append(r as! RemoteUnit)
            default:
                fatalError("change reason not implemented")
            }
        }
        insert(creates, into: context.context)
        deleteUnits(with: deletionIDs, in: context.context)
        update(updates, in: context.context)
        context.delayedSaveOrRollback()
        completion()
    }

    func fetchLatestRemoteRecords(in context: ChangeProcessorContext) {
        remote.fetchLatestRecords(completion: { (remoteUnits) in
            context.perform {
                self.insert(remoteUnits, into: context.context)
                context.delayedSaveOrRollback()
            }
        })
    }

    func entityAndPredicateForLocallyTrackedObjects(in context: ChangeProcessorContext) -> EntityAndPredicate<NSManagedObject>? {
        return nil
    }

}


extension UnitDownloader {

    fileprivate func deleteUnits(with ids: [RemoteIdentifier], in context: NSManagedObjectContext) {
        guard !ids.isEmpty else { return }
        let units = Unit.fetch(in: context) { (request) -> () in
            request.predicate = Unit.predicateForRemoteIdentifiers(ids)
            request.returnsObjectsAsFaults = false
        }
        units.forEach { $0.markForLocalDeletion() }
    }

    fileprivate func insert(_ remoteUnits: [RemoteUnit], into context: NSManagedObjectContext) {
        let existingUnits = { () -> [RemoteIdentifier: Unit] in
            let ids = remoteUnits.map { $0.id }.flatMap { $0 }
            let units = Unit.fetch(in: context) { request in
                request.predicate = Unit.predicateForRemoteIdentifiers(ids)
                request.returnsObjectsAsFaults = false
            }
            var result: [RemoteIdentifier: Unit] = [:]
            for unit in units {
                result[unit.remoteIdentifier!] = unit
            }
            return result
        }()

        for remoteUnit in remoteUnits {
            guard existingUnits[remoteUnit.id] == nil else { continue }
            _ = remoteUnit.insert(into: context)
        }
    }
    
    fileprivate func update(_ updates: [RemoteUnit], in context: NSManagedObjectContext) {
        
    }

}

