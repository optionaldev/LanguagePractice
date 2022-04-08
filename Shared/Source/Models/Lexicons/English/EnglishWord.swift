//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

protocol EnglishItem: Item {
  
}

protocol EnglishWord: EnglishItem {
  
}

extension EnglishWord {
  
  var imageExists: Bool {
    return false
  }
}
