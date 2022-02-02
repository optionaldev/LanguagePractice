//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct EnglishLexicon: Codable {
  
  let nouns: [EnglishNoun]
  let adjectives: [EnglishAdjective]
  
  init() {
    nouns = []
    adjectives = []
  }
  
  var all: [EnglishWord] {
    return nouns as [EnglishWord] +
    adjectives as [EnglishWord]
  }
}
