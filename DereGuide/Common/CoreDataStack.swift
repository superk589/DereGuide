//
//  CoreDataStack.swift
//  DereGuide
//
//  Created by zzk on 2017/7/10.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let `default` = CoreDataStack()
    
    private init() {
        // still have some error in switching store of core data at runtime
//        NotificationCenter.default.addObserver(self, selector: #selector(handleiCloudAccountChanged), name: .NSUbiquityIdentityDidChange, object: nil)
    }
    
    deinit {
//        NotificationCenter.default.removeObserver(self)
    }
    
//    @objc func handleiCloudAccountChanged() {
//        // switch persistentStore after user change their iCloud account
//        guard let currentStore = coordinator.persistentStores.first else {
//            return
//        }
//        do {
//            try coordinator.remove(currentStore)
//            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: nil)
//            viewContext.perform { [weak self] in
//                self?.viewContext.refreshAllObjects()
//                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: self?.viewContext.registeredObjects.map { $0.objectID } ?? []], into: [self?.viewContext].flatMap { $0 })
//                self?.viewContext.reset()
//            }
//            syncContext.perform { [weak self] in
//                self?.syncContext.refreshAllObjects()
//                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: self?.syncContext.registeredObjects.map { $0.objectID } ?? []], into: [self?.syncContext].flatMap { $0 })
//                self?.syncContext.reset()
//            }
//        } catch let error {
//            print(error)
//        }
//    }
    
    private let ubiquityToken: String = {
        guard let token = FileManager.default.ubiquityIdentityToken else { return "unknown" }
        let string = NSKeyedArchiver.archivedData(withRootObject: token).base64EncodedString(options: [])
        return string.removingCharacters(in: CharacterSet.letters.inverted).md5()
    }()
    
    private lazy var storeURL: URL = URL.documents.appendingPathComponent("\(self.ubiquityToken).cgssguide")
    
    @available(iOS 10.0, *)
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DereGuide")
        let storeDescription = NSPersistentStoreDescription(url: self.storeURL)
        container.persistentStoreDescriptions = [storeDescription]
        let semaphore = DispatchSemaphore(value: 0)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            semaphore.signal()
        })
        semaphore.wait()
//        storeDescription.shouldMigrateStoreAutomatically = false
        return container
    }()
    
    private lazy var coordinator: NSPersistentStoreCoordinator = {
        if #available(iOS 10.0, *) {
            return self.container.persistentStoreCoordinator
        } else {
            let bundles = [Bundle(for: Unit.self)]
            guard let model = NSManagedObjectModel.mergedModel(from: bundles) else {
                fatalError("model not found")
            }
            let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
            try! psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
            return psc
        }
    }()
    
    private(set) lazy var viewContext: NSManagedObjectContext = {
        if #available(iOS 10.0, *) {
            return self.container.viewContext
        } else {
            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.persistentStoreCoordinator = self.coordinator
            return context
        }
    }()
    
    private(set) lazy var syncContext: NSManagedObjectContext = {
        if #available(iOS 10.0, *) {
            return self.container.newBackgroundContext()
        } else {
            // 如果并发存在问题, 再考虑使用多个协调器, 暂时使用同一个协调器
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.persistentStoreCoordinator = self.coordinator
            return context
        }
    }()
    
    func newChildContext(parent: NSManagedObjectContext, concurrencyType: NSManagedObjectContextConcurrencyType? = nil) -> NSManagedObjectContext {
        
        return parent.newChildContext(concurrencyType: concurrencyType)
    }
    
}
