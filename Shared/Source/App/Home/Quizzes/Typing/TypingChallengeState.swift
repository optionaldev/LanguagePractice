//
// The LanguagePractice project.
// Created by optionaldev on 22/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 
//
//import struct Foundation.TimeInterval
//
//private struct Constants {
//  
//  static let incorrectGuessStoreValue: String = "-"
//}
//
//enum OldTypingChallengeState: Hashable, Codable {
//  
//  case guessedIncorrectly
//  case finished(_ interval: TimeInterval, _ answerIndex: Int)
//  
//  var storeValue: String {
//    switch self {
//      case .guessedIncorrectly:
//        return Constants.incorrectGuessStoreValue
//      case .finished(let interval, let answerIndex):
//        return "\(interval) \(answerIndex)"
//    }
//  }
//  
//  // MARK: - Codable conformance
//  
//  init(from decoder: Decoder) throws {
//    let container = try decoder.singleValueContainer()
//    
//    let value = try container.decode(String.self)
//    let components = value.split(separator: " ")
//    
//    if let intervalString = components.first,
//       let answerIndexString = components.last,
//       let interval = TimeInterval(intervalString),
//       let answerIndex = Int(answerIndexString)
//    {
//      self = .finished(interval, answerIndex)
//    } else {
//      self = .guessedIncorrectly
//    }
//  }
//  
//  func encode(to encoder: Encoder) throws {
//    var encoder = encoder.singleValueContainer()
//    try encoder.encode(storeValue)
//  }
//}
