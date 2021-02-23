//
//  CoreDataStackManager.swift
//  Find My Lunch
//
//  Created by Vasco d'Orey on 18/01/2021.
//

import Foundation
import CoreData
import Promises
import OSLog


protocol CoreDataServiceProtocol: ServiceProtocol {
    
    var storeName: String { get }
    
    var storeURL: URL { get }
    
    var managedObjectModel: NSManagedObjectModel { get }
    
    var persistentStore: NSPersistentStore { get }
    
    var mainCoordinator: NSPersistentStoreCoordinator { get }
    
    var mainContext: NSManagedObjectContext { get }
    
    func save(_ block: @escaping (NSManagedObjectContext) -> ()) -> Promise<Bool>
    
    func clearAllData() -> Promise<Bool>
    
}

@objc private class ContextNotificationHandler: NSObject {
    
    var handler: ((NSNotification) -> ())?
    
    @objc func contextDidSave(_ note: NSNotification) {
        self.handler?(note)
    }
    
}


final class CoreDataService: CoreDataServiceProtocol {
    
    static var serviceName: String = "\(CoreDataServiceProtocol.self)"
    
    var storeName: String
    
    var storeURL: URL
    
    var managedObjectModel: NSManagedObjectModel
    
    var persistentStore: NSPersistentStore
    
    var mainCoordinator: NSPersistentStoreCoordinator
    
    var mainContext: NSManagedObjectContext
    
    private var notificationHandler: ContextNotificationHandler
    
    var fileService: FileServiceProtocol
    
    init(storeName: String) {
        self.storeName = storeName
        self.fileService = registeredService()
        self.storeURL = self.fileService.applicationSupportDirectory.appendingPathComponent(storeName)
        self.managedObjectModel = validate(NSManagedObjectModel.mergedModel(from: Bundle.allBundles))
        self.mainCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption : true,
                NSInferMappingModelAutomaticallyOption : true
            ]
            self.persistentStore = try self.mainCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: options)
        }
        catch {
            preconditionFailure(error.localizedDescription)
        }
        
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        self.notificationHandler = ContextNotificationHandler()
        
        self.mainContext.performAndWait {
            self.mainContext.persistentStoreCoordinator = self.mainCoordinator
            self.mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
        
    }
    
    func save(_ block: @escaping (NSManagedObjectContext) -> ()) -> Promise<Bool> {
        return Promise { [unowned self] (success, failure) in
            let child = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            
            child.parent = self.mainContext
            
            child.perform {
                block(child)
                
                child._performSave().then { (result) -> Promise<Bool> in
                    return self.mainContext._performSave()
                    }.then { (_) -> Void in
                        success(true)
                    }.catch { (error) in
                        self.log(.error, "%@", error.localizedDescription)
                        failure(error)
                }
            }
        }
    }
    
    func clearAllData() -> Promise<Bool> {
        return save { [unowned self] (context) in
            let entities = self.managedObjectModel.entities
        }
    }
    
}
