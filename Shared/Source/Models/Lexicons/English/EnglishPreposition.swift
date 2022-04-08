//
// The LanguagePractice project.
// Created by optionaldev on 04/04/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

struct EnglishPreposition: EnglishWord {
  
  let id: String
  let clarification: String?
  let reference: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case clarification = "cl"
    case reference     = "rf"
  }
}
