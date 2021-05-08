//
// The LanguagePractice project.
// Created by optionaldev on 08/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

protocol ChallengeProtocol: Equatable, Identifiable {
  
  var inputType: ChallengeType { get }
  var input: String { get }
  var inputRepresentation: Rep { get }
  
  var output: [String] { get }
}
