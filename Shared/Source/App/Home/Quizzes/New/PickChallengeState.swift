//
// The LanguagePractice project.
// Created by optionaldev on 09/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import struct Foundation.TimeInterval

private struct Constants {
  
  static let incorrectGuessStoreValue: TimeInterval = -1
}

enum PickChallengeState: TimeStorable, Hashable, Codable {
  
  case guessedIncorrectly
  case finished(_ interval: TimeInterval)
  
  var storeValue: TimeInterval {
    switch self {
      case .guessedIncorrectly:
        return -1
      case .finished(let interval):
        return interval
    }
  }
  
  // MARK: - Codable conformance
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    
    let value = try container.decode(TimeInterval.self)
    
    if value == Constants.incorrectGuessStoreValue {
      self = .guessedIncorrectly
    } else {
      self = .finished(value)
    }
  }
  
  func encode(to encoder: Encoder) throws {
    var encoder = encoder.singleValueContainer()
    try encoder.encode(storeValue)
  }
}
