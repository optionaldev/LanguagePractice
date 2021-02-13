//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct ForeignNoun: ForeignWord, Hashable {
    
    let id: String
    let characters: String
    let english: [String]
    
    #if JAPANESE
    let furigana: String?
    #endif
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case characters = "ch"
        case english    = "en"
        
        #if JAPANESE
        case furigana   = "fg"
        #endif
    }
}
