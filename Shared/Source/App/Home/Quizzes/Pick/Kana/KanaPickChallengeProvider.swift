//
// The LanguagePractice project.
// Created by optionaldev on 16/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

enum Possibility {
  
  case image
  case text
  case voice
}

final class KanaPickChallengeProvider: ChallengeProvidable {
  
  init(lexicon: Lexicon = .shared) {
    self.lexicon = lexicon
  }
  
  // MARK: - ChallengeProvidable conformance
  
  func generateTyping(fromPool pool: [Distinguishable], index: Int) -> TypingChallenge {
    fatalError()
  }
  
  func generatePick(fromPool pool: [Distinguishable], index: Int) -> PickChallenge {
    let pool = pool.compactMap { $0 as? KanaEntry }
    let entry = pool[index]
    
    guard let character = lexicon.foreignDictionary[entry.id] as? ForeignCharacter else {
      fatalError("Couldn't find character with id \"\(entry.id)\"")
    }
    
    let source: [ForeignCharacter]
    if character.written.containsHiragana {
      source = lexicon.foreign.hiragana
    } else {
      source = lexicon.foreign.katakana
    }
    
    let otherCharacters = source
            .filter { $0.id != character.id }
            .shuffled()
            .prefix(5)
            .map { $0 }
    
    let voiceEnabled = entry.category.voiceValid && Defaults.voiceEnabled
    
    let inputType: Possibility  //= entry.category.input(voiceEnabled: Defaults.voiceEnabled)
    switch entry.category {
      case .foreign:
        inputType = voiceEnabled ? [.voice, .text].randomElement()! : .text
      case .english:
        inputType = .text
    }
    
    
    let input: InputRepresentation
    let outputType: Possibility  //entry.category.output(forInput: inputType, voiceEnabled: Defaults.voiceEnabled)
    
    switch inputType {
      case .image:
        fatalError("Not possible")
      case .text:
        switch entry.category {
          case .english:
            outputType = .text
          case .foreign:
            outputType = voiceEnabled ? [.voice, .text].randomElement()! : .text
        }
      case .voice:
        outputType = .text
    }
    
    let correctOutput: OutputRepresentation
    var otherOutput: [OutputRepresentation]
    
    switch inputType {
      case .text:
        switch entry.category {
          case .foreign:
            input = .text(character.written)
            switch outputType {
              case .text:
                correctOutput = .text(character.romaji)
                otherOutput = otherCharacters.map { .text($0.romaji) }
              case .voice:
                correctOutput = .voice(character.spoken)
                otherOutput = otherCharacters.map { .voice($0.spoken) }
              case .image:
                fatalError("Can't have images in this type of challenge")
            }
          case .english:
            input = .text(character.romaji)
            switch outputType {
              case .text:
                correctOutput = .text(character.written)
                otherOutput = otherCharacters.map { .text($0.written) }
              case .voice:
                correctOutput = .voice(character.spoken)
                otherOutput = otherCharacters.map { .voice($0.spoken) }
              case .image:
                fatalError("Can't have images in this type of challenge")
            }
        }
      case .voice:
        input = .voice(character.spoken)
        switch entry.category {
          case .foreign:
            correctOutput = .text(character.romaji)
            otherOutput = otherCharacters.map { .text($0.romaji) }
          case .english:
            correctOutput = .text(character.written)
            otherOutput = otherCharacters.map { .text($0.written) }
        }
      case .image:
        fatalError("Can't have images in this type of challenge")
    }
    
    otherOutput.append(correctOutput)
    otherOutput.shuffle()
    
    guard let correctAnswerIndex = otherOutput.firstIndex(of: correctOutput) else {
      fatalError("Couldn't find correct answer in list of answers.")
    }
    
    return PickChallenge(inputRep: input, outputRep: otherOutput, correctAnswerIndex: correctAnswerIndex)
  }
  
  // MARK: - Private
  
  private let lexicon: Lexicon
}
