//
// The LanguagePractice project.
// Created by optionaldev on 08/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct TextWithTranslationRep: CustomStringConvertible {
  
  let text: String
  let language: Language
  let translation: String
  
  // MARK: - CustomStringConvertible conformance
  
  var description: String {
    return "text = \"\(text)\" language = \(language) translation = \"\(translation)\""
  }
}
