//
// The LanguagePractice project.
// Created by optionaldev on 11/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import class AVFoundation.AVAudioSession
import class AVFoundation.AVSpeechSynthesizer
import class AVFoundation.AVSpeechUtterance
import class Foundation.DispatchQueue
import class Foundation.NSObject

import protocol AVFoundation.AVSpeechSynthesizerDelegate

protocol SpeechDelegate: class {
  
  func speechStarted()
  func speechEnded()
}

extension SpeechDelegate {
  
  func speechStarted() {}
}

final class Speech: NSObject, AVSpeechSynthesizerDelegate {
  
  static let shared = Speech()
  
  weak var delegate: SpeechDelegate?
  
  override init() {
    englishVoice = VoiceHandler(.english)
    foreignVoice = VoiceHandler(.foreign)
    synthesizer = AVSpeechSynthesizer()
    
    super.init()
    
    synthesizer.delegate = self
    
    // If utterance is used for the first time in the app, there's a ~1 second delay
    // Do a 0 volume utterance in order to prevent that initial delay during challenges
    speak(string: "", language: .english, volume: 0)
  }
  
  func speak(string: String, language: Language, volume: Float = 1.0, rate: Float = 0.5) {
    var string = string
    
    // Otoya-premium does not correctly pronounce these, but the sound generated by
    // the kanji in the right side is how the letters on the left side should be
    // pronounced, so we use the kanji for pronounciation. There will be exceptions.
    // Most of the time, when 2 or more kanji are pronounced together, their sound
    // changes, but we will deal with each case in particular
    string = string.replacingOccurrences(of: "した", with: "下")
    string = string.replacingOccurrences(of: "しか", with: "鹿")
    string = string.replacingOccurrences(of: "して", with: "仕手")
    string = string.replacingOccurrences(of: "しく", with: "敷く")
    
    let utterance = AVSpeechUtterance(string: string)
    utterance.voice = language == .english ? englishVoice.next() : foreignVoice.next()
    
    if language == .english && utterance.voice?.misspronounces(word: string) == true {
      utterance.voice = englishVoice.next()
    }
    
    utterance.pitchMultiplier = 1
    utterance.rate = rate
    utterance.volume = volume
    
    log("Speaking \"\(string)\" with voice: \(String(describing: utterance.voice?.name))")
    
    synthesizer.speak(utterance)
  }
  
  // MARK: - AVSpeechSynthesizerDelegate conformance
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    handleSynthesizer(started: true)
  }
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    handleSynthesizer(started: false)
  }
  
  // MARK: - Private
  
  private let synthesizer: AVSpeechSynthesizer
  private var foreignVoice: VoiceHandler
  private var englishVoice: VoiceHandler
  
  private func handleSynthesizer(started: Bool) {
    if started {
      delegate?.speechStarted()
    } else {
      delegate?.speechEnded()
    }
    
    #if os(iOS)
    DispatchQueue.global(qos: .userInteractive).async {
      do {
        try AVAudioSession.sharedInstance().setActive(started)
      } catch {
        log("AVAudioSession.sharedInstance().setActive(started) error = \(error)")
      }
    }
    #endif
  }
}

