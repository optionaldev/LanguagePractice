//
// The LanguagePractice project.
// Created by optionaldev on 16/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct KanaRepresentation: Equatable {
  
  enum Category {
    case text
    case voice
  }
  
  let category: Category
  let string: String
}
