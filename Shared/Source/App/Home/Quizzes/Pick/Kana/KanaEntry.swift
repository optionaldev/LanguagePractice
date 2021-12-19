//
// The LanguagePractice project.
// Created by optionaldev on 14/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

struct KanaEntry {
  
  enum Category: CaseIterable {
    case foreign
    case english
    
    private var voiceValid: Bool {
      switch self {
        case .foreign:
          return true
        case .english:
          return false
      }
    }
    
    var validOutput: Self {
      switch self {
        case .foreign:
          return .english
        case .english:
          return .foreign
      }
    }
    
    func input(voiceEnabled: Bool) -> Possibility {
      switch self {
        case .foreign:
          return voiceEnabled && voiceValid ? [.text, .voice].randomElement()! : .text
        case .english:
          return .text
      }
    }
    
    func output(forInput input: Possibility, voiceEnabled: Bool) -> Possibility {
      switch input {
        case .image:
          fatalError("not possible")
        case .text:
          switch validOutput {
            case .foreign:
              return voiceEnabled && validOutput.voiceValid ? [.text, .voice].randomElement()! : .text
            case .english:
              return .text
          }
        case .voice:
          return .text
      }
    }
  }
  
  let id: String
  let category: Category
}
