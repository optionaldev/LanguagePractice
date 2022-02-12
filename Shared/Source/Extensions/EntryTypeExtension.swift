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
