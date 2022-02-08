//
// The LanguagePractice project.
// Created by optionaldev on 08/02/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

struct ConjugationVariation {
  
  let tense: Tense
  let negative: Bool
  let type: ConjugationType
  
  func representation(spoken: Bool) -> String {
    var result: String = ""
    
    switch type {
      case .modifier:
        break
      case .formalEnding:
        result.append("formal ")
      case .informalEnding:
        result.append("informal ")
    }
    
    if negative {
      if spoken {
        result.append("negative ")
      } else {
        result.append("neg. ")
      }
    }
    
    result.append(tense.rawValue)
    
    switch type {
      case .modifier:
        result.append(" as modifier")
      case .formalEnding, .informalEnding:
        break
    }
    
    return result
  }
}
