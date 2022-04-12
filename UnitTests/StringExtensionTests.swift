//
// The UnitTests project.
// Created by optionaldev on 03/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

@testable import LanguagePractice

import XCTest

class StringExtensionTests: XCTestCase {
  
  func testUniqueIndetifier() throws {
    let possibleKeys = [
      "Number 1",
      "hot_1",
      "cold_1"
    ]
    
    let expectedResults = [
      "Number 1",
      "hot",
      "cold"
    ]
    
    let results = possibleKeys.map { $0.removingUniqueness() }
    
    for (index, value) in results.enumerated() {
      XCTAssertEqual(value, expectedResults[index])
    }
  }
}
