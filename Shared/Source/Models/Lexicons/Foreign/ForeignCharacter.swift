//
// The LanguagePractice project.
// Created by optionaldev on 28/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct ForeignCharacter: ForeignItem {
  
  var id: String
  var written: String
  
  init(id: String, characters: String) {
    self.id = id
    self.written = characters
  }
  
  enum CodingKeys: String, CodingKey {
    
    case id
    case written = "ch"
  }
}
