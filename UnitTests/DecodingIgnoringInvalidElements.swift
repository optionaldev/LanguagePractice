//
// The UnitTests project.
// Created by optionaldev on 10/04/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

import Foundation
import XCTest

@propertyWrapper
struct LossyCodableList<Element> {
  var elements: [Element]
  
  var wrappedValue: [Element] {
    get {
      elements
    }
    set {
      elements = newValue
    }
  }
}

extension LossyCodableList: Decodable where Element: Decodable {
  
  private struct ElementWrapper: Decodable {
    var element: Element?
    
    init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      element = try? container.decode(Element.self)
    }
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let wrappers = try container.decode([ElementWrapper].self)
    elements = wrappers.compactMap(\.element)
  }
}

extension LossyCodableList: Encodable where Element: Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    
    for element in elements {
      try? container.encode(element)
    }
  }
}


struct ArrayElement: Decodable {
  var text: String
  var id: String
  var description: String?
}

struct ArrayOfElements: Decodable {
  
  @LossyCodableList var items: [ArrayElement]
}

func XCTSuccess() {
  XCTAssertTrue(true)
}

class ArrayOfElementsDecoding: XCTestCase {
  
  func testDecodingArrayOfElements() throws {
    
    let string = """
{
    "items": [{
      "text": "First item",
      "id": "1"
    },
              {
      "text": "Second item",
      "id": "2",
      "description": "the 2nd"
    },
              {
      "text": "Third item"
    }
    ]
  }
"""
    let data = string.data(using: .utf8)
    
    do {
      let array = try JSONDecoder().decode(ArrayOfElements.self, from: data!)
      XCTAssertTrue(array.items.isEmpty)
      print(array)
    } catch {
      XCTFail("XCTFailed with error \(error)")
    }
    
  }
}
