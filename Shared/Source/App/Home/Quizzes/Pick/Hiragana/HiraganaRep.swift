//
// The LanguagePractice project.
// Created by optionaldev on 16/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct HiraganaRep: Equatable {
  
  enum Category {
    case image
    case text
    case voice
  }
  
  let category: Category
  let string: String
}
