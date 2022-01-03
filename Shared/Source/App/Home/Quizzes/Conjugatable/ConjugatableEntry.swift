//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 03/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

enum ConjugatableEntryCategory: CategoryProtocol {
  
  case askCorrectForm
  case askTense
  
  var voiceValid: Bool {
    return true
  }
}

struct ConjugatableEntry: Entryable {
  
  let id: String
  let category: ConjugatableEntryCategory
}
