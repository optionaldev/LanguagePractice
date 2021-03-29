//
// The LanguagePractice project.
// Created by optionaldev on 11/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class AVFoundation.AVSpeechSynthesisVoice


extension Language {
    
    var voices: [AVSpeechSynthesisVoice] {
        return AVSpeechSynthesisVoice.speechVoices().filter { voice in
            // Interstingly enough, on macOS, voices are by default enhanced, but trying to
            // filter voices using `$0.quality == .enhanced` doesn't work because the
            // AVSpeechSynthesisVoiceQuality only contains rawValues 1 & 2 and voices
            // fetched using the `speechVoices()` method have `quality` rawValue 0
            voiceNames.contains(voice.name) && voice.quality != .default
        }
    }
    
    // MARK: - Private
    
    private var voiceNames: [String] {
        switch self {
        case .english:
            #if os(macOS)
            return ["Alex", "Daniel", "Moira", "Samantha", "Tessa", "Tom", "Lee"]
            #else
            // These seem to be the voices that correctly pronounce the vast majority
            // of words and high a relatively decent output in terms of voice quality
            return ["Lee", "Tom"]
            #endif
        case .foreign:
            // Even though there is Kyoko premium, is sounds like lower quality than Otoya
            #if JAPANESE
            return ["Otoya"]
            #endif
        }
    }
}
