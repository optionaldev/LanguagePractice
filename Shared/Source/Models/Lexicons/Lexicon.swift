//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

/**
 Basically a real life dictionary, but dictionary
 terminology was avoided due to pre-existing structure.
 */
final class Lexicon: Codable {
  
  static let shared: Lexicon! = Defaults.lexicon
  
  let english: EnglishLexicon
  let foreign: ForeignLexicon
  
  lazy var englishDictionary: [String: EnglishItem] = {
    english.all.reduce(into: [String: EnglishItem]()) { $0[$1.id] = $1 }
  }()
  
  lazy var foreignDictionary: [String: ForeignItem] = {
    foreign.all.reduce(into: [String: ForeignItem]()) { $0[$1.id] = $1 }
  }()
  
  init(english: EnglishLexicon, foreign: ForeignLexicon) {
    self.english = english
    self.foreign = foreign
  }
}
