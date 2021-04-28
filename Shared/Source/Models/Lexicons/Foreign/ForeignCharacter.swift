//
// The LanguagePractice project.
// Created by optionaldev on 28/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct ForeignCharacter: ForeignItem {
    
    var characters: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        
        case characters = "ch"
        case id
    }
}
