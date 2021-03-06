//
// The LanguagePractice project.
// Created by optionaldev on 11/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

enum HomeQuiz: String, CaseIterable, Identifiable {
  
  case hiragana
  case katakana
  case words
  
  var title: String {
    switch self {
      case .hiragana:
        return "Basic Hiragana"
      case .katakana:
        return "Basic Katakana"
      case .words:
        return "Simple words"
    }
  }
  
  // MARK: - Identifiable conformance
  
  var id: String {
    return rawValue
  }
}
