//
// The LanguagePractice project.
// Created by optionaldev on 14/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

enum KanaEntryCategory: CategoryProtocol {
  
  case foreign
  case english
  
  var voiceValid: Bool {
    switch self {
      case .foreign:
        return true
      case .english:
        return false
    }
  }
  
  static var all: [Self] {
    return [.english, .foreign]
  }
}

struct KanaEntry: Entryable {
  
  let id: String
  let category: KanaEntryCategory
}
