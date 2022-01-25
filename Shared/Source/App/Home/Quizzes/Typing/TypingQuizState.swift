//
// The LanguagePractice project.
// Created by optionaldev on 23/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 
//
//import Foundation
//
//enum TypingQuizState: Equatable {
//  
//  case regular
//  
//  /// Amount of times the user needs to write one of the words before proceeding to the next challenge
//  case forfeited(_ remaining: Int)
//  
//  // MARK: - Equatable conformance
//  
//  static func ==(lhs: Self, rhs: Self) -> Bool {
//    switch lhs {
//      case .regular:
//        return rhs == .regular
//      case .forfeited(let lhsRemaining):
//        if case .forfeited(let rhsRemaining) = rhs {
//          return lhsRemaining == rhsRemaining
//        }
//        return false
//    }
//  }
//}
