//
// The LanguagePractice project.
// Created by optionaldev on 13/06/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

enum EntryType: CaseIterable {
  
  case hiragana
  case katakana
  case words
  case conjugateAdjectives
  case conjugateVerbs
  
  var title: String {
    switch self {
      case .hiragana:
        return "Hiragana"
      case .katakana:
        return "Katakana"
      case .words:
        return "New words"
      case .conjugateAdjectives:
        return "Conjugate adjectives"
      case .conjugateVerbs:
        return "Conjugate verbs"
    }
  }
}
