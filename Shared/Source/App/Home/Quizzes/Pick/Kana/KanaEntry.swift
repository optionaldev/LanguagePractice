//
// The LanguagePractice project.
// Created by optionaldev on 14/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

struct KanaEntry {
  
  let id: String
  let category: Category
  
  enum Category: CaseIterable {
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
  }
}
