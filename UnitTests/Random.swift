//
// The UnitTests project.
// Created by optionaldev on 04/05/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

@testable import LanguagePractice

import XCTest
import Foundation

class UnitRandom: XCTestCase {

    func testRandomDouble() throws {
        let lowerBound = 0.02
        let upperBound = 0.05
        let doubleRange = lowerBound..<upperBound
        
        for _ in 0..<1000 {
            let random = Random.double(inRange: doubleRange)
            print(random)
            XCTAssertTrue(random >= lowerBound)
            XCTAssertTrue(random < upperBound)
        }
    }
}
