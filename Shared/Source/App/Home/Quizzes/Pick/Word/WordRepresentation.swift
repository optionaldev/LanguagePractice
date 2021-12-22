//
// The LanguagePractice project.
// Created by optionaldev on 22/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

struct FuriganaRep {
  
  let string: [String]
  let furigana: [String]
}

enum WordRepresentation {
  
  case text(_ text: String)
  case textWithTranslation(_ textWithTranslationRep: TextWithTranslationRep)
  case uniformFurigana(_ rep: FuriganaRep)
  case nonUniformFurigana(_ rep: FuriganaRep)
  case voice(_ spoken: String)
  case image(_ imageId: String)
  
  var string: String {
    switch self {
      case .text(let rep),
           .voice(let rep),
           .image(let rep):
        return rep
      case .textWithTranslation(let rep):
        return rep.text
      case .uniformFurigana(let rep),
           .nonUniformFurigana(let rep):
        return rep.string.joined() + rep.furigana.joined()
    }
  }
}
