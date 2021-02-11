//
// The LanguagePractice project.
// Created by optionaldev on 11/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import AVFoundation

extension Language {
    
    var voices: [AVSpeechSynthesisVoice] {
        AVSpeechSynthesisVoice.speechVoices().filter {
            languageIDs.contains($0.language) && identifiers.contains($0.identifier)
        }
    }
    
    var languageIDs: [String] {
        switch self {
        case .english:
            // These seem to be the voices that correctly pronounce the vast majority
            // of words and high a relatively decent output in terms of voice quality
            return ["en-US",    // US accent
                    "en-GB",    // British accent
                    "en-AU",    // Australian accent
                    "en-ZA",    // South African accent
                    "en-IE"]    // Irish accent
        case .foreign:
            #if JAPANESE
            return ["ja-JP"]
            #endif
        }
    }
    
    var identifiers: [String] {
        let voiceNames: [String]
        switch self {
        case .english:
            voiceNames = ["Lee", "Tom"]
        case .foreign:
            // Even though there is Kyoko premium, is sounds like lower quality than Otoya
            #if JAPANESE
            voiceNames = ["Otoya"]
            #endif
        }
        return voiceNames.map { prefix + $0 + postfix }
    }
    
    // MARK: - Private
    
    private var prefix: String {
        "com.apple.ttsbundle."
    }
    
    private var postfix: String {
        "-premium"
    }
}
