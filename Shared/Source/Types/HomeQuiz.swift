//
// The LanguagePractice project.
// Created by optionaldev on 11/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

extension EntryType: Distinguishable {
  
  var title: String {
    switch self {
      case .hiragana:
        return "Hiragana"
      case .katakana:
        return "Katakana"
      case .words:
        return "Simple words"
      case .conjugateAdjectives:
        return "Adjectives"
      case .conjugateVerbs:
        return "Verbs"
    }
  }
  
  var id: String {
    return title
  }
}
//
//enum HomeQuiz: String, CaseIterable, Distinguishable {
//  
//  case hiragana
//  case katakana
//  case words
//  
//  var title: String {
//    switch self {
//      case .hiragana:
//        return "Basic Hiragana"
//      case .katakana:
//        return "Basic Katakana"
//      case .words:
//        return "Simple words"
//      case .:
//        return "Simple words"
//      case .words:
//        return "Simple words"
//    }
//  }
//  
//  // MARK: - Distinguishable conformance
//  
//  var id: String {
//    return rawValue
//  }
//}
