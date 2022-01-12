//
// The LanguagePractice project.
// Created by optionaldev on 19/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

struct WordEntry: Entryable {
  
  let id: String
  let category: Category
  
  enum Category: CategoryProtocol {
    case foreign
    case english
    
    var voiceValid: Bool {
      return true
    }
    
    static var all: [Self] {
      return [.foreign, .english]
    }
  }
}
