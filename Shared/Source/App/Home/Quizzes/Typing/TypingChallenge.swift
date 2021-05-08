//
// The LanguagePractice project.
// Created by optionaldev on 21/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct TypingChallenge: ChallengeProtocol, Identifiable, Equatable {
  
  let output: [String]
  var state: TypingChallengeState?
  
  var inputRepresentation: Rep = .textWithTranslation(.init(text: "-",
                                                            language: .english,
                                                            translation: ""))
  
  
  init(inputType: ChallengeType,
       input: String,
       inputRepresentation: Rep,
       output: [String]) {
    self.inputType = inputType
    self.input = input
    self.inputRepresentation = inputRepresentation
    self.output = output
  }
  
  // MARK: - ChallengeProtocol conformance
  
  let inputType: ChallengeType
  let input: String
  
  // MARK: - Codable conformance
  
  enum CodingKeys: String, CodingKey {
    
    case inputType
    case input
    case output
    case state
  }
  
  // MARK: - Equatable conformance
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.inputType == rhs.inputType &&
      lhs.input == rhs.input &&
      lhs.state == rhs.state
  }
  
  // MARK: - Identifiable conformance
  
  var id: String {
    return input
  }
}
