//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 03/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
//

enum Tense {
  
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
}

protocol ForeignConjugatable: Identifiable {
  
}

