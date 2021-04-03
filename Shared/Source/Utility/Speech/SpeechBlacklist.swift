//
// The LanguagePractice project.
// Created by optionaldev on 11/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import AVFoundation

// These represent words that certain speech synthesizers can't pronounce well
private enum SpeechBlacklist: String, CaseIterable {
    
    case tom = "Tom"
    case lee = "Lee"
    
    var misspronouncedWords: [String] {
        switch self {
        case .tom:
            return ["irritation", "dog"]
        case .lee:
            return []
        }
    }
}

extension AVSpeechSynthesisVoice {
    
    func misspronounces(word: String) -> Bool {
        guard let blacklist = SpeechBlacklist(rawValue: name) else {
            return false
        }
        return blacklist.misspronouncedWords.contains(word)
    }
}
