//
//  ServiceTests.swift
//  DeltaKitTests
//
//  Created by Vasco d'Orey on 22/02/2021.
//

import XCTest
@testable import DeltaKit
import CwlPreconditionTesting

protocol SimpleServiceProtocol: ServiceProtocol {}

final class SimpleService: SimpleServiceProtocol {}

final class NonConformingService {}

class ServiceTests: XCTestCase {

    override func tearDownWithError() throws {
        ServiceLocator.shared.clearAllServices()
    }

    func testSimpleService() {
        let simple = SimpleService()
        
        ServiceLocator.shared.register(service: simple as SimpleServiceProtocol)
        
        let converted = simple as SimpleServiceProtocol
        
        let result: SimpleServiceProtocol = ServiceLocator.shared.fetch().validated
        
        XCTAssertTrue(converted === result)
    }
    
    func testServiceOverwriting() {
        let simple = SimpleService()
        
        ServiceLocator.shared.register(service: simple as SimpleServiceProtocol)
        
        let converted = simple as SimpleServiceProtocol
        
        let next = SimpleService()
        
        ServiceLocator.shared.register(service: next as SimpleServiceProtocol)
        
        let nextConverted = next as SimpleServiceProtocol
        
        let result: SimpleServiceProtocol = ServiceLocator.shared.fetch().validated
        
        XCTAssertTrue(nextConverted === result)
        XCTAssertFalse(converted === result)
    }
    
    func testEmptyFetch() {
        let result: SimpleServiceProtocol? = ServiceLocator.shared.fetch()
        
        XCTAssertNil(result)
    }
    
    func testEnque() {
        let simple = SimpleService()
        var result = false
        
        let expect = expectation(description: "Should be called on register")
        
        ServiceLocator.shared.with(execute: { (obj: SimpleServiceProtocol) in
            result = true
            
            expect.fulfill()
        })
        
        ServiceLocator.shared.register(service: simple as SimpleServiceProtocol)
        
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertTrue(result)
        }
    }
    
    func testClear() {
        let simple = SimpleService()
        
        ServiceLocator.shared.register(service: simple as SimpleServiceProtocol)
        
        var result: SimpleServiceProtocol? = ServiceLocator.shared.fetch()
        
        XCTAssertNotNil(result)
        
        ServiceLocator.shared.clearAllServices()
        
        result = ServiceLocator.shared.fetch()
        
        XCTAssertNil(result)
    }
    
    func testSpecificImplementationIsNil() {
        let simple = SimpleService()
        
        ServiceLocator.shared.register(service: simple as SimpleServiceProtocol)
        
        let result: SimpleService? = ServiceLocator.shared.fetch()
        
        XCTAssertNil(result)
    }
    
    func testNonConformingServiceFatalError() {
        let tester = NonConformingService()
        var reachedPoint1 = false
        var reachedPoint2 = false
        let exception1: CwlPreconditionTesting.BadInstructionException? = catchBadInstruction {
            // Must invoke this block
            reachedPoint1 = true
            
            // Fatal error raised
            ServiceLocator.shared.register(service: tester)

            // Exception must be thrown so that this point is never reached
            reachedPoint2 = true
        }
        XCTAssertNotNil(exception1)
        XCTAssertTrue(reachedPoint1)
        XCTAssertFalse(reachedPoint2)
    }

}
