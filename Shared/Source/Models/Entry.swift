//
// The LanguagePractice project.
// Created by optionaldev on 10/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct Entry: Equatable {
    
    let from: Language
    let to: Language
 
    let input: String
    let output: String
    
    var type: (Language, Language) {
        return (from, to)
    }
    
    // No guarantee to have english text because it might be a 'simplified' type challenge
    var english: String? {
        from == .english ? input : (to == .english ? output : nil)
    }
    
    var foreign: String {
        from == .foreign ? input : output
    }
    
    var noImage: Bool {
        if let english = english {
            return Persistence.imagePath(id: english) == nil
        } else {
            return false
        }
    }
}
