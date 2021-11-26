//
// The LanguagePractice project.
// Created by optionaldev on 28/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

protocol ForeignItem: Item {
  
  #if JAPANESE
  /**
   Roman representation of japanese characters. Equivalent to _roman_ for Japanese words.
   
   Examples:
   - **りんご** → **ringo**
   - **テレビ** → **terebi**
   - **自転車** → **jitensha**
   */
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
