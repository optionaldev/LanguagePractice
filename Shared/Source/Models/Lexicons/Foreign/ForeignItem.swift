//
// The LanguagePractice project.
// Created by optionaldev on 28/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

protocol ForeignItem: Item {
  
  #if JAPANESE
  var romaji: String { get }
  #endif
}

extension ForeignItem {
    
  #if JAPANESE
  var romaji: String {
    return roman
  }
  #endif
}
