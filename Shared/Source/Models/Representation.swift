//
// The LanguagePractice project.
// Created by optionaldev on 08/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct TextWithTranslationRep: CustomStringConvertible {
    
    let text: String
    let language: Language
    let translation: String
    
    // MARK: - CustomStringConvertible conformance
    
    var description: String {
        return "text = \"\(text)\" language = \(language) translation = \"\(translation)\""
    }
}

struct TextWithFuriganaRep: CustomStringConvertible {
    
    let text: [String]
    let furigana: [String]
    let english: String
    
    // MARK: - CustomStringConvertible conformance
    
    var description: String {
        return "text = \(text) furigana = \(furigana) english = \"\(english)\""
    }
}

struct ImageRep: CustomStringConvertible {
    
    let imageID: String
    
    // MARK: - CustomStringConvertible conformance
    
    var description: String {
        return "imageID = \"\(imageID)\""
    }
}

struct SimpleRep: CustomStringConvertible {
    
    let text: String
    let language: Language
    
    // MARK: - CustomStringConvertible conformance
    
    var description: String {
        return "text = \"\(text)\" language = \(language)"
    }
}

enum Rep: CustomStringConvertible {
    
    case simpleText(SimpleRep)
    case textWithTranslation(TextWithTranslationRep)
    case textWithFurigana(TextWithFuriganaRep)
    case image(ImageRep)
    case voice(SimpleRep)
    
    // MARK: - CustomStringConvertible conformance
    
    var description: String {
        switch self {
        case .simpleText(let rep):
            return "simpleText(\(rep))"
        case .textWithTranslation(let rep):
            return "textWithTranslation(\(rep))"
        case .textWithFurigana(let rep):
            return "textWithFurigana(\(rep))"
        case .image(let rep):
            return "image(\(rep))"
        case .voice(let rep):
            return "voice(\(rep))"
        }
    }
    
    var voiceChallenge: Bool {
        if case .voice = self {
            return true
        }
        return false
    }
}
