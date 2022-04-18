//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct ForeignNoun: ForeignWord, Hashable {
  
  let id: String
  let written: String
  let english: [String]
  
  var uncommonWriting: Bool {
    return uncommon == 1
  }
  
  #if JAPANESE
  let furigana: String?
  let jlpt: Int?
  
  var groupFurigana: Bool {
    return irregularKana == 1
  }
  
  var shouldReadKana: Bool {
    return readKana == 1
  }
  #endif
  
  enum CodingKeys: String, CodingKey {
    
    case id
    case written  = "ch"
    case english  = "en"
    case uncommon = "un"
    case jlpt     = "jl"
    
    #if JAPANESE
    case furigana      = "fg"
    case irregularKana = "ik"
    case readKana      = "rk"
    #endif
  }
  
  // MARK: - Private
  
  private var uncommon: Int?
  
  #if JAPANESE
  /// Absence of this value means we should just read the characters
  private var readKana: Int?
  
  /// Irregular furigana means that not every kanji has an equivalent hiragana representation
  /// Instead, the hiragana representation applies to all kanjis combined
  private var irregularKana: Int?
  #endif
}
