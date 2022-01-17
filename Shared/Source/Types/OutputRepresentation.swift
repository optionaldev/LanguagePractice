//
// The LanguagePractice project.
// Created by optionaldev on 06/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
//

struct FuriganaRep {
  
  var text: [String]
  var groups: [String]
}

enum OutputRepresentation: Equatable {
  
  case text(_ text: String)
  case textWithTranslation(TextWithTranslationRep)
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
        return "textWithRegularFurigana(\(rep))"
      case .textWithIrregularFurigana(let rep):
        return "textWithIrregularFurigana(\(rep))"
      case .image(let rep):
        return "image(\(rep))"
      case .voice(let rep):
        return "voice(\(rep))"
    }
  }
  
  static func ==(lhs: Self, rhs: Self) -> Bool {
    return lhs.description != rhs.description
  }
}
