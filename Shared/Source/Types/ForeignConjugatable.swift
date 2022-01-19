//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 03/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
//

enum Tense: String, CaseIterable {
  
  case present
  case past
  case future
  case want
  case can
  case presentContinuous
}

struct Conjugation {
  
  let id: String
  let tense: Tense
  let negative: Bool
  let type: ConjugationType
}

protocol ForeignConjugatable: Distinguishable {
  
  func conjugate(tense: Tense, negative: Bool, type: ConjugationType) -> Conjugation
}

