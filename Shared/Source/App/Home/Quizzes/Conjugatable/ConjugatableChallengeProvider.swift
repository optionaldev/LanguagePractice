//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 03/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

final class ConjugatableChallengeProvider {
  
  init(lexicon: Lexicon = .shared, speech: Speech = .shared) {
    self.lexicon = lexicon
    self.speech = speech
  }
  
  func generate(fromPool pool: [ConjugatableEntry], index: Int) -> ConjugatablePickChallenge {
    let entry = pool[index]
    
    guard let conjugatable = lexicon.foreignDictionary[entry.id] as? ForeignConjugatable else {
      fatalError("Couldn't find conjugatable with id: \"\(entry.id)\"")
    }
    
    guard let word = lexicon.foreignDictionary[entry.id] as? ForeignWord else {
      fatalError("Couldn't find word with id: \"\(entry.id)\"")
    }
    
    // TODO: Improve
    let voiceEnabled = speech.voicePossible(forEntry: entry)
    
    let inputType: Possibility = voiceEnabled ? [.voice, .text].randomElement()! : .text
    
    let input: InputRepresentation
    let outputType: Possibility = voiceEnabled ? [.voice, .text].randomElement()! : .text
    
    let correctOutput: OutputRepresentation
    var otherOutput: [OutputRepresentation]
    
    switch inputType {
      case .image:
        fatalError("Not possible")
      case .text:
        switch entry.category {
          case .askTense:
            let string = conjugatable.conjugate(tense: .present, negative: .random(), type: .regular).id
            let text = "Tense of\n\"\(string)\""
            input = .simpleText(text)
            switch outputType {
              case .image, .voice:
                fatalError("Not possible")
              case .text:
                otherOutput = Tense.allCases.without(.present).map {
                  .simpleText($0.rawValue) }
                correctOutput = .simpleText("present")
            }
          case .askCorrectForm:
            let text = "Present form of\n\"\(word.written)\""
            input = .simpleText(text)
            switch outputType {
              case .image:
                fatalError("Not possible")
              case .text:
                otherOutput = Tense.allCases.without(.present).map { .simpleText(conjugatable.conjugate(tense: $0, negative: .random(), type: .regular).id) }
                correctOutput = .simpleText(conjugatable.conjugate(tense: .present, negative: false, type: .regular).id)
              case .voice:
                otherOutput = Tense.allCases.without(.present).map { .voice(conjugatable.conjugate(tense: $0, negative: .random(), type: .regular).id) }
                correctOutput = .voice(conjugatable.conjugate(tense: .present, negative: false, type: .regular).id)
            }
        }
      case .voice:
        switch entry.category {
          case .askTense:
            let string = conjugatable.conjugate(tense: .present, negative: .random(), type: .regular).id
            let text = "Tense of\n\"\(string)\""
            input = .voice(text)
            switch outputType {
              case .image, .voice:
                fatalError("Not possible")
              case .text:
                otherOutput = Tense.allCases.without(.present).map { .simpleText($0.rawValue) }
                correctOutput = .simpleText("present")
            }
          case .askCorrectForm:
            let text = "Present form of\n\"\(word.written)\""
            input = .simpleText(text)
            switch outputType {
              case .image:
                fatalError("Not possible")
              case .text:
                otherOutput = Tense.allCases.without(.present).map { .simpleText(conjugatable.conjugate(tense: $0, negative: .random(), type: .regular).id) }
                correctOutput = .simpleText(conjugatable.conjugate(tense: .present, negative: false, type: .regular).id)
              case .voice:
                otherOutput = Tense.allCases.without(.present).map { .voice(conjugatable.conjugate(tense: $0, negative: .random(), type: .regular).id) }
                correctOutput = .voice(conjugatable.conjugate(tense: .present, negative: false, type: .regular).id)
            }
        }
    }
    otherOutput.append(correctOutput)
    otherOutput.shuffle()
    
    guard let correctAnswerIndex = otherOutput.firstIndex(where: { $0.description == correctOutput.description }) else {
      fatalError("Couldn't find correct answer in list of answers.")
    }
    
    return .init(inputRep: input, outputRep: otherOutput, correctAnswerIndex: correctAnswerIndex)
  }
  
  // MARK: - Private
  
  private let lexicon: Lexicon
  private let speech: Speech
}
