//
// The LanguagePractice project.
// Created by optionaldev on 11/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import AVFoundation

struct VoiceHandler {
  
  init(_ language: Language) {
    self.language = language
  }
  
  mutating func next() -> AVSpeechSynthesisVoice? {
    let voices = language.voices
    if index == voices.count {
      index = 0
    }
    let currentIndex = index
    index += 1
    return currentIndex < voices.count ? voices[currentIndex] : nil
  }
  
  // MARK: - Private
  
  private var index = 0
  private let language: Language
}
