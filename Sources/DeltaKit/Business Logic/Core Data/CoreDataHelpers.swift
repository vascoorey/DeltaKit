//
//  CoreDataHelpers.swift
//  DeltaKit
//
//  Created by Vasco d'Orey on 18/01/2021.
//

import Foundation
import CoreData
import Promises

extension NSManagedObjectContext {
    
    static var mainContext: NSManagedObjectContext {
        get {
            let stackManager: CoreDataServiceProtocol = registeredService()
            
            return stackManager.mainContext
        }
    }
    
    func _performSave() -> Promise<Bool> {
        return Promise { (success, failure) in
            self.perform {
                if self.hasChanges {
                    do {
                        try self.save()
                    }
                    catch {
                        failure(error)
                        
                        return
                    }
                }
                
                success(true)
            }
        }
    }
    
}

