//
//  CoreDataServiceTests.swift
//  DeltaKitTests
//
//  Created by Vasco d'Orey on 23/02/2021.
//

import XCTest
@testable import DeltaKit

class CoreDataServiceTests: XCTestCase {
    
    var storeName = "testing"
    
    override func setUpWithError() throws {
        let fileService = FileService()
        ServiceLocator.shared.register(service: fileService as FileServiceProtocol)
        let coreData = CoreDataService(storeName: storeName)
        ServiceLocator.shared.register(service: coreData as CoreDataServiceProtocol)
    }
    
    override func tearDownWithError() throws {
        let fileService: FileServiceProtocol = registeredService()
        
        let storeURL = fileService.applicationSupportDirectory.appendingPathComponent(storeName)
        
        try FileManager.default.removeItem(at: storeURL)
        
        ServiceLocator.shared.clearAllServices()
    }
    
    func testModelIsLoaded() {
        let coreData: CoreDataServiceProtocol = registeredService()
        
        XCTAssertNotNil(coreData.managedObjectModel)
        XCTAssertNotNil(coreData.persistentStore)
        XCTAssertNotNil(coreData.mainCoordinator)
        XCTAssertNotNil(coreData.mainContext)
    }

}
