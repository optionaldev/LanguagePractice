//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct Lexicon: Codable {
    
    var english: EnglishLexicon
    var foreign: ForeignLexicon
    
    lazy var englishDictionary: [String: EnglishWord] = {
        english.nouns.reduce(into: [String: EnglishWord]()) { $0[$1.id] = $1 }
    }()
    
    lazy var foreignDictionary: [String: ForeignWord] = {
        foreign.nouns.reduce(into: [String: ForeignWord]()) { $0[$1.id] = $1 }
    }()
    
    init(english: EnglishLexicon, foreign: ForeignLexicon) {
        self.english = english
        self.foreign = foreign
    }
}
