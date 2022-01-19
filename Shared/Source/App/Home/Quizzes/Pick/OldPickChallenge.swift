//
// The LanguagePractice project.
// Created by optionaldev on 09/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct OldPickChallenge: ChallengeProtocol {
  
  let outputType: ChallengeType
  let output: [String]
  let correctAnswerIndex: Int
  
  var state: OldPickChallengeState?
  
  // inputRepresentation and outputRepresentation can change during a challenge
  // so they're not part of what we save
  var inputRepresentation: Rep = .textWithTranslation(.init(text: "-",
                                                            language: .english,
                                                            translation: ""))
  var outputRepresentations: [Rep] = []
  
  init(inputType: ChallengeType,
       input: String,
       outputType: ChallengeType,
       output: [String],
       correctAnswerIndex: Int,
       inputRepresentations: Rep,
       outputRepresentations: [Rep]) {
    self.inputType = inputType
    self.input = input
    self.outputType = outputType
    self.output = output
    self.correctAnswerIndex = correctAnswerIndex
    self.inputRepresentation = inputRepresentations
    self.outputRepresentations = outputRepresentations
  }
  
  // MARK: - ChallengeProtocol conformance
  
  let inputType: ChallengeType
  let input: String
  
  // MARK: - Codable conformance
  
  enum CodingKeys: String, CodingKey {
    
    case inputType
    case input
    case outputType
    case output
    case correctAnswerIndex
    case state
  }
  
  // MARK: - Equatable conformance
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.inputType == rhs.inputType &&
      lhs.input == rhs.input &&
      lhs.outputType == rhs.outputType &&
      lhs.output == rhs.output &&
      lhs.correctAnswerIndex == rhs.correctAnswerIndex &&
      lhs.state == rhs.state
  }
  
  // MARK: - Distinguishable conformance
  
  var id: String {
    return input + output[correctAnswerIndex] + "\(inputType.storeValue) \(outputType.storeValue)"
  }
}
