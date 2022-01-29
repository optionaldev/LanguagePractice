//
// The LanguagePractice project.
// Created by optionaldev on 11/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import AVFoundation

// These represent words that certain speech synthesizers can't pronounce well
private enum SpeechBlacklist: String, CaseIterable {
  
  case alex
  case lee
  case samantha
  case tom
  
  var misspronouncedWords: [String] {
    switch self {
      case .alex:
        return ["hit"]
      case .lee:
        return []
      case .samantha:
        return ["map"]
      case .tom:
        return ["irritation", "dog"]
    }
  }
}

extension AVSpeechSynthesisVoice {
  
  func misspronounces(word: String) -> Bool {
    guard let blacklist = SpeechBlacklist(rawValue: name.lowercased()) else {
      return false
    }
    return blacklist.misspronouncedWords.contains(word)
  }
}
