//
// The LanguagePractice project.
// Created by optionaldev on 06/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
//

struct TranslationRep {
  
  let text: String
  let translation: String
}

enum InputRepresentation {

  case text( _ text: String)
  case textWithTranslation(TranslationRep)
  case textWithRegularFurigana(FuriganaRep)
  case textWithIrregularFurigana(FuriganaRep)
  case image(_ id: String)
  case voice(_ spoken: String)
  
  var description: String {
    switch self {
      case .text(let rep):
        return "simpleText(\(rep))"
      case .textWithTranslation(let rep):
        return "textWithTranslation(\(rep))"
      case .textWithRegularFurigana(let rep):
        return "textWithFurigana(\(rep))"
      case .textWithIrregularFurigana(let rep):
        return "textWithFurigana(\(rep))"
      case .image(let rep):
        return "image(\(rep))"
      case .voice(let rep):
        return "voice(\(rep))"
    }
  }
}
