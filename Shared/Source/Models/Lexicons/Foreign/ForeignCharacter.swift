//
// The LanguagePractice project.
// Created by optionaldev on 28/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct ForeignCharacter: ForeignItem {
  
  var characters: String
  var id: String
  
  var speech: String {
    return characters
  }
  
  init(id: String, characters: String) {
    self.id = id
    self.characters = characters
  }
  
  enum CodingKeys: String, CodingKey {
    
    case characters = "ch"
    case id
  }
}
