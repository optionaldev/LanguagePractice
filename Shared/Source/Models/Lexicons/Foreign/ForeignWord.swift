//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

protocol ForeignWord: Word {
    
    var characters: String { get }
    var furigana: String? { get }
    var english: [String] { get }
}
