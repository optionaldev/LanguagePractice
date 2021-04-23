//
// The LanguagePractice project.
// Created by optionaldev on 03/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

enum DefaultsCodingKey: String, Storable {
    
    case englishLexicon
    case foreignLexicon
}

enum DefaultsArrayKey: String, Storable {
    
    // Currently unused
    case wordsLearned
}

enum DefaultsBoolKey: String, Storable {
    
    case voiceEnabled
}

enum DefaultsDictionaryKey: String, Storable {
    
    case hiraganaGuessHistory
    case katakanaGuessHistory
    case wordGuessHistory
}

enum DefaultsStringKey: String, Storable {
    
    case kanjiFontName
}
