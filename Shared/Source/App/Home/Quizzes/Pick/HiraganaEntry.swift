//
// The LanguagePractice project.
// Created by optionaldev on 14/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 


struct HiraganaEntry {
 
  enum Category: CaseIterable {
    case hiraganaToRomaji   // な(t) -> na
    case hiraganaToVoice    // な(t) -> な(v)
    case romajiToHiragana   // na -> な(t)
    case romajiToVoice      // na -> な(v)
    case voiceToRomaji      // な(v) -> na
    case voiceToHiragana    // な(v) -> な(t)
    
    var voiceFallback: Self {
      switch self {
        case .hiraganaToVoice:
          return .hiraganaToRomaji
        case .romajiToVoice:
          return .romajiToHiragana
        case .voiceToRomaji:
          return .hiraganaToRomaji
        case .voiceToHiragana:
          return .romajiToHiragana
        case .hiraganaToRomaji,
            .romajiToHiragana:
          return self
      }
    }
  }
  
  let id: String
  let category: Category
}

struct HiraganaRep {
  
  enum Category {
    case image
    case text
    case voice
  }
  
  let category: Category
  let string: String
}

struct HiraganaChallenge {
  
  let inputRep: HiraganaRep
  let outputRep: [HiraganaRep] // x4 or x6
  
  let correctAnswerIndex: Int
}
