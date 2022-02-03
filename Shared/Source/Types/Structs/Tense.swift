//
// The LanguagePractice project.
// Created by optionaldev on 26/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
//

struct ConjugationVariation: Speakable {
  
  let tense: Tense
  let negative: Bool
  let type: ConjugationType
  
  var spoken: String {
    var result: String = ""
    if negative {
      result.append("negative ")
    }
    switch type {
      case .regular:
        result.append("regular ")
      case .formalEnding:
        result.append("formal ")
      case .informalEnding:
        result.append("informal ")
    }
    
    // TODO: Handle present continuous
    return result.appending(tense.rawValue)
  }
}

enum Tense: String, CaseIterable {
  
  case present
  case past
  case future
  case want
  case can
  case presentContinuous
}
