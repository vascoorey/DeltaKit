//
//  HelperTests.swift
//  DeltaKitTests
//
//  Created by Vasco d'Orey on 23/02/2021.
//

import XCTest
@testable import DeltaKit
import CwlPreconditionTesting

class HelperTests: XCTestCase {

    func testValidateWithNilData() {
        var reachedPoint1 = false
        var reachedPoint2 = false
        let exception1: CwlPreconditionTesting.BadInstructionException? = catchBadInstruction {
            // Must invoke this block
            reachedPoint1 = true
            
            // Fatal error raised
            let str: String? = nil
            
            let _ = str.validated

            // Exception must be thrown so that this point is never reached
            reachedPoint2 = true
        }
        XCTAssertNotNil(exception1)
        XCTAssertTrue(reachedPoint1)
        XCTAssertFalse(reachedPoint2)
    }
    
    func testValidateWithGoodData() {
        var reachedPoint1 = false
        var reachedPoint2 = false
        let exception1: CwlPreconditionTesting.BadInstructionException? = catchBadInstruction {
            // Must invoke this block
            reachedPoint1 = true
            
            // Fatal error raised
            let str: String? = "good"
            
            let _ = str.validated

            // Exception must be thrown so that this point is never reached
            reachedPoint2 = true
        }
        XCTAssertNil(exception1)
        XCTAssertTrue(reachedPoint1)
        XCTAssertTrue(reachedPoint2)
    }

}
