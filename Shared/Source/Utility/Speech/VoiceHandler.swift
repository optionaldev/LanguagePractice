//
// The LanguagePractice project.
// Created by optionaldev on 11/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class AVFoundation.AVSpeechSynthesisVoice

struct VoiceHandler {
  
  init(_ language: Language) {
    self.language = language
  }
  
  mutating func next() -> AVSpeechSynthesisVoice? {
    let voices = language.voices
    guard !voices.isEmpty else {
      return nil
    }
    if index >= voices.count {
      index = 0
    }
    let currentIndex = index
    index += 1
    return voices[currentIndex]
  }
  
  var hasVoices: Bool {
    return language.voices.count != 0
  }
  
  // MARK: - Private
  
  private var index = 0
  private let language: Language
}
