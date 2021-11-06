//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct ForeignNoun: ForeignWord, Hashable {
  
  let id: String
  let written: String
  let english: [String]
  
  #if JAPANESE
  let furigana: String?
  #endif
  
  var shouldReadKana: Bool {
    return readKana == 1
  }
  
  enum CodingKeys: String, CodingKey {
    
    case id
    case written  = "ch"
    case english  = "en"
    case readKana = "rk"
    
    #if JAPANESE
    case furigana   = "fg"
    #endif
  }
  
  // MARK: - Private
  
  /// Absence of this value means we should just read the characters
  private var readKana: Int?
}
