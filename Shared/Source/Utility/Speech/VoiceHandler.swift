//
// The LanguagePractice project.
// Created by optionaldev on 11/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import AVFoundation

struct VoiceHandler {
    
    init(_ type: Language) {
        self.voices = type.voices
    }
    
    mutating func next() -> AVSpeechSynthesisVoice {
        if index == voices.count {
            index = 0
        }
        let currentIndex = index
        index += 1
        return voices[currentIndex]
    }
    
    // MARK: - Private
    
    private var index = 0
    private var voices: [AVSpeechSynthesisVoice]
}
