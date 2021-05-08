//
// The LanguagePractice project.
// Created by optionaldev on 28/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

protocol ForeignItem: Item {
  
  // The word represented in a foreign using that foreign language's alphabet(s)
  var characters: String { get }
  
}
