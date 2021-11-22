//
// The LanguagePractice project.
// Created by optionaldev on 28/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct ForeignCharacter: ForeignItem {
  
  let id: String
  let written: String
  let position: [Int]
  
  enum CodingKeys: String, CodingKey {
    
    case id
    case written  = "ch"
    case position = "po"
  }
}
