//
// The LanguagePractice project.
// Created by optionaldev on 19/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct WordEntry {
  
  let id: String
  let category: Category
  
  enum Category: CaseIterable {
    case foreign
    case english
    
    var voiceValid: Bool {
      return true
    }
  }
}
