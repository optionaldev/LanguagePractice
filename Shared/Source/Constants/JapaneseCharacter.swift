//
// The LanguagePractice project.
// Created by optionaldev on 10/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

#if JAPANESE
struct JapaneseCharacter: ForeignCharacter {

    let character: String
    
    var romaji: String {
        fatalError("Romaji generation used before implementing")
    }
    
    var valid: Bool {
        character != "　"
    }
    
    init(_ character: String) {
        self.character = character
    }
}
#endif
