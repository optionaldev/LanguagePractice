//
// The LanguagePractice project.
// Created by optionaldev on 03/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

enum DefaultsCodingKey: String, CodingStorable {
    
    case englishLexicon
    case foreignLexicon
}

enum DefaultsArrayKey: String, CodingStorable {
    
    // Currently unused
    case wordsLearned
}

enum DefaultsDictionaryKey: String, CodingStorable {
    
    case guessHistory
}
