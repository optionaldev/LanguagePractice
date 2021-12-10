//
// The LanguagePractice project.
// Created by optionaldev on 10/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct ForeignVerb: ForeignWord {
  
  let id: String
  let written: String
  let english: [String]
  
  #if JAPANESE
  let furigana: String?
  
  var groupFurigana: Bool {
    return irregularKana == 1
  }
  
  var shouldReadKana: Bool {
    return readKana == 1
  }
  #endif
  
  enum CodingKeys: String, CodingKey {
    case id
    case written = "ch"
    case english = "en"
    
    #if JAPANESE
    case furigana = "fg"
    case irregularKana = "ik"
    case readKana = "rk"
    #endif
  }
  
  // MARK: - Private
  
  private var readKana: Int?
  
  private var irregularKana: Int?
}
