//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 03/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
//

protocol ForeignConjugatable: Distinguishable {
  
  func conjugate(tense: Tense, negative: Bool, type: ConjugationType) -> Conjugation
  func conjugate(variation: ConjugationVariation) -> Conjugation
  
  static var possibleTenses: [Tense] { get }
}

extension ForeignConjugatable {
  
  func conjugate(variation: ConjugationVariation) -> Conjugation {
    return conjugate(tense: variation.tense, negative: variation.negative, type: variation.type)
  }
}

