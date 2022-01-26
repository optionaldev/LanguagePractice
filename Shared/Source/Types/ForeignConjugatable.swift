//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 03/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
//

struct Conjugation {
  
  let id: String
  let tense: Tense
  let negative: Bool
  let type: ConjugationType
}

protocol ForeignConjugatable: Distinguishable {
  
  func conjugate(tense: Tense, negative: Bool, type: ConjugationType) -> Conjugation
}

