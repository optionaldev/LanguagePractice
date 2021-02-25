//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct Lexicon: Codable {
    
    var english: EnglishLexicon
    var foreign: ForeignLexicon
    
    lazy var englishDictionary: [String: EnglishNoun] = {
        english.nouns.reduce(into: [String: EnglishNoun]()) { $0[$1.id] = $1 }
    }()
    
    lazy var foreignDictionary: [String: ForeignNoun] = {
        foreign.nouns.reduce(into: [String: ForeignNoun]()) { $0[$1.id] = $1 }
    }()
}
