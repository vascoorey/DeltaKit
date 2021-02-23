//
//  FileServiceTests.swift
//  
//
//  Created by Vasco d'Orey on 23/02/2021.
//

import XCTest
@testable import DeltaKit
import CwlPreconditionTesting

class FileServiceTests: XCTestCase {
    
    func testFileServiceInitialization() {
        var reachedPoint1 = false
        var reachedPoint2 = false
        let exception1: CwlPreconditionTesting.BadInstructionException? = catchBadInstruction {
            reachedPoint1 = true
            let service = FileService()
            XCTAssertNotNil(service)
            XCTAssertNotNil(service.applicationSupportDirectory)
            reachedPoint2 = true
        }
        XCTAssertNil(exception1)
        XCTAssertTrue(reachedPoint1)
        XCTAssertTrue(reachedPoint2)
    }
    
}
