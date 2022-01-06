//
// The LanguagePractice project.
// Created by optionaldev on 06/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

enum OutputRepresentation {
  
  case simpleText(_ text: String)
  case textWithTranslation(TextWithTranslationRep)
  case textWithFurigana(TextWithFuriganaRep)
  case image(_ id: String)
  case voice(_ spoken: String)
  
  var description: String {
    switch self {
      case .simpleText(let rep):
        return "simpleText(\(rep))"
      case .textWithTranslation(let rep):
        return "textWithTranslation(\(rep))"
      case .textWithFurigana(let rep):
        return "textWithFurigana(\(rep))"
      case .image(let rep):
        return "image(\(rep))"
      case .voice(let rep):
        return "voice(\(rep))"
    }
  }
}
