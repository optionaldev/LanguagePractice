//
// The LanguagePractice project.
// Created by optionaldev on 24/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

final class ChallengeProvider {
  
  static func generateInputComponents(entry: EntryProtocol) -> (ChallengeType, String, Rep) {
    let inputType = generateInputType(for: entry)
    let input = generateInput(for: entry, inputType: inputType)
    let inputRep = generateInputRep(for: entry, inputType: inputType, input: input)
    
    return (inputType, input, inputRep)
  }
  
  static func generatePick(pool: [EntryProtocol], index: Int) -> OldPickChallenge {
    let entry = pool[index]
    let (inputType, input, inputRep) = generateInputComponents(entry: entry)
    
    let outputType = generateOutputType(for: entry, inputType: inputType)
    var output = generateOutput(for: entry, outputType: outputType, pool: pool)
    
    let answerOutput: String
    if entry is KanaEntryProtocol {
      answerOutput = entry.output
    } else {
      // Handle the case where output is already kana in nextEntry for simplified case
      if entry.outputLanguage == .english {
        answerOutput = entry.output
      } else if entry.inputLanguage == .foreign && entry.outputLanguage == .foreign {
        answerOutput = entry.input
      } else {
        answerOutput = Lexicon.shared.foreignDictionary[entry.output]?.id ?? ""
      }
    }
    output.append(answerOutput)
    output.shuffle()
    
    let outputRep = generateOutputRep(for: entry, outputType: outputType, output: output)
    let correctAnswerIndex = output.firstIndex(of: answerOutput)!
    
    return OldPickChallenge(inputType: inputType,
                            input: input,
                            outputType: outputType,
                            output: output,
                            correctAnswerIndex: correctAnswerIndex,
                            inputRepresentations: inputRep,
                            outputRepresentations: outputRep)
  }
  
  private static func item(for entry: EntryProtocol) -> ForeignItem {
    guard let nextForeignItem = Lexicon.shared.foreignDictionary[entry.foreignID] else {
      log("No foreign word with ID = \"\(entry.foreignID)\" found in dictionary", type: .unexpected)
      fatalError("")
    }
    return nextForeignItem
  }
  
  static func generateTyping(pool: [EntryProtocol], index: Int) -> TypingChallenge {
    let entry = pool[index]
    let (inputType, input, inputRep) = generateInputComponents(entry: entry)
    
    let output: [String]
    switch entry.outputLanguage {
      case .english:
        output = entry.output.split(separator: ",").map { String($0) }
      case .foreign:
        let nextForeignItem = item(for: entry)
        if let word = nextForeignItem as? ForeignWord {
          // TODO: Add option in settings for switching between output types
          output = [word.romaji, word.kana, word.written].compactMap { $0 }
        } else {
          output = [nextForeignItem.romaji]
        }
    }
    
    return TypingChallenge(inputType: inputType,
                           input: input,
                           inputRepresentation: inputRep,
                           output: output)
  }
  
  static var lexicon = Defaults.lexicon!
  
  private static func generateInputType(for entry: EntryProtocol) -> ChallengeType {
    var inputTypePossibilities = entry.inputPossibilities
    
    // In case there's no images found, we can't create image based challenges
    // For entries that don't have "from" as english, it doens't make sense to create an image based challenge
    // We would just end up trying to guess if an image representing a concept matching an english word,
    // which defeats the purpose of trying to learn a foreign word
    if entry.noImage || entry.inputLanguage != .english {
      inputTypePossibilities.removing(.image)
    }
    
    if entry is OldWordEntry {
      if entry.inputLanguage == entry.outputLanguage {
        return .simplified
      } else {
        inputTypePossibilities.removing(.simplified)
        
        // `entry.to` represents the output type, but here we're trying to generate the input type
        // and aside from simplified challenge, input & output are never the same language
        inputTypePossibilities.removing(.voice(entry.outputLanguage))
        inputTypePossibilities.removing(.text(entry.outputLanguage))
      }
    }
    
    guard let randomInputType = inputTypePossibilities.randomElement() else {
      fatalError("Array should never be empty after applying filters")
    }
    
    return randomInputType
  }
  
  private static func generateInput(for entry: EntryProtocol, inputType: ChallengeType) -> String {
    if inputType == .text(.foreign) || inputType == .voice(.foreign) || inputType == .simplified {
      guard let inputWord = Lexicon.shared.foreignDictionary[entry.foreignID] else {
        fatalError("Tried to fetch entry with ID \"\(entry.foreignID)\" from foreign dictionary")
      }
      
      return inputWord.id
    } else {
      // For images and english input types, we simply use the input
      return entry.input
    }
  }
  
  private static func generateInputRep(for entry: EntryProtocol, inputType: ChallengeType, input: String) -> Rep {
    let nextForeignItem = item(for: entry)
    
    switch inputType {
      case .text(let language):
        switch language {
          case .english:
            return .simpleText(.init(text: entry.input.removingUniqueness(),
                                     language: .english))
          case .foreign:
            if let word = nextForeignItem as? ForeignWord {
              if word.hasFurigana {
                if word.groupFurigana {
                  return .textWithFurigana(.init(text: [word.written],
                                                 furigana: word.kanaComponents,
                                                 english: entry.output.removingUniqueness()))
                } else {
                  return .textWithFurigana(.init(text: word.written.map { String($0) },
                                                 furigana: word.kanaComponents,
                                                 english: entry.output.removingUniqueness()))
                }
              } else {
                return .simpleText(.init(text: nextForeignItem.written,
                                         language: .foreign))
              }
            } else {
              return .simpleText(.init(text: entry.input, language: .foreign))
            }
        }
      case .voice(let language):
        switch language {
          case .english:
            return .voice(.init(text: entry.input.removingUniqueness(),
                                language: .english))
          case .foreign:
            return .voice(.init(text: nextForeignItem.written,
                                language: .foreign))
        }
      case .image:
        return .image(.init(imageID: input))
      case .simplified:
        return .textWithTranslation(.init(text: nextForeignItem.written,
                                          language: .foreign,
                                          translation: entry.output.removingUniqueness()))
    }
  }
  
  // MARK: Output
  
  private static func generateOutputType(for entry: EntryProtocol, inputType: ChallengeType) -> ChallengeType {
    if inputType == .simplified {
      return .simplified
    }
    
    if entry is OldWordEntry == false {
      guard let result = entry.outputPossibilities.without(inputType).randomElement() else {
        fatalError("How did we get here?")
      }
      return result
    }
    
    var validOutputTypeForInput: [ChallengeType]
    
    switch inputType {
      case .text(let language):
        switch language {
          case .english:
            validOutputTypeForInput = [.text(.foreign), .voice(.foreign)]
          case .foreign:
            validOutputTypeForInput = [.text(.english)]
            if Persistence.imagePath(id: entry.output) != nil {
              validOutputTypeForInput.append(.image)
            }
        }
      case .voice(let language):
        switch language {
          case .english:
            validOutputTypeForInput = [.text(.foreign), .voice(.foreign)]
          case .foreign:
            validOutputTypeForInput = [.text(.english)]
            
            if Persistence.imagePath(id: entry.output) != nil {
              validOutputTypeForInput.append(.image)
            }
            // TODO: draw kanji option maybe?
        }
      case .image:
        validOutputTypeForInput = [.text(.foreign), .voice(.foreign)]
      case .simplified:
        validOutputTypeForInput = [.text(.foreign)]
    }
    
    let validOutputTypeSet = Set(validOutputTypeForInput)
    let possibleOutputTypeSet = Set(entry.outputPossibilities)
    let outputTypeSet = possibleOutputTypeSet.intersection(validOutputTypeSet)
    
    guard let outputType = outputTypeSet.randomElement() else {
      fatalError("Set is empty after filters are applied")
    }
    
    return outputType
  }
  
  private static func generateOutput(for entry: EntryProtocol, outputType: ChallengeType, pool: [EntryProtocol]) -> [String] {
    
    let nextItem = item(for: entry)
    
    var otherSameTypeChallengeEntries = pool.filter { $0.typeIndex == entry.typeIndex && $0.foreignID != entry.foreignID }
    if let word = nextItem as? ForeignWord {
      let other = otherSameTypeChallengeEntries.filter { $0.english == nil ||
        !word.english.contains($0.english!) }
      otherSameTypeChallengeEntries = other
    }
    
    if entry is KanaEntryProtocol {
      let challenges = otherSameTypeChallengeEntries.map { $0.output }
      
      return challenges.removingDuplicates().shuffled().prefix(5).map { $0 }
    }
    
    var output: [String]
    switch outputType {
      case .image:
        // Get a list of all input, which in our scenario can only represent english IDs
        //            let otherChallengeEntryIDs = otherSameTypeChallengeEntries.map { $0.output }
        // TODO: Handle when current challenge doesn't countain 5 images
        let otherChallengeEntryIDs = Lexicon.shared.english.nouns.map { $0.id }
        
        // Get a list of all images available for current english IDs
        output = otherChallengeEntryIDs.filter { Persistence.imagePath(id: $0) != nil }
        
        output.removing(entry.english!)
        
        // TODO: Handle picking images from other entries
        log("Before filtering, found \(output.count) entries with images")
        
        if output.count < 6 {
          fatalError("Not enough images")
        }
        
      case .simplified:
        output = otherSameTypeChallengeEntries.map { $0.input }
        
      case .text(let language):
        switch language {
          case .english:
            output = Array(otherSameTypeChallengeEntries.map { $0.output })
          case .foreign:
            let outputIDs = Array(otherSameTypeChallengeEntries.map { $0.output })
            output = outputIDs.compactMap { lexicon.foreignDictionary[$0]?.id }
        }
        
      case .voice(let language):
        switch language {
          case .english:
            output = Array(otherSameTypeChallengeEntries.map { $0.output })
          case .foreign:
            if entry is OldWordEntry {
              let outputIDs = Array(otherSameTypeChallengeEntries.map { $0.output })
              output = outputIDs.compactMap { Lexicon.shared.foreignDictionary[$0]?.id }
            } else {
              output = otherSameTypeChallengeEntries.map { $0.output }
            }
        }
    }
    
    output = Array(output.removingDuplicates().prefix(5))
    
    guard output.count == 5 else {
      fatalError("`output` should have exactly 5 entries")
    }
    
    return output
  }
  
  private static func generateOutputRep(for entry: EntryProtocol, outputType: ChallengeType, output: [String]) -> [Rep] {
    let result: [Rep]
    
    if entry is KanaEntryProtocol {
      switch outputType {
        case .text(let language):
          result = output.map { Rep.simpleText(.init(text: $0, language: language)) }
        case .voice(let language):
          switch language {
            case .english:
              fatalError("We don't want to read \"a\" with english voice")
            case .foreign:
              result = output.map { Rep.voice(.init(text: $0, language: .foreign)) }
          }
        case .image, .simplified:
          fatalError("Not possible to have these output types")
      }
    } else {
      
      switch outputType {
        case .image:
          result = output.map { Rep.image(.init(imageID: $0)) }
        case .simplified:
          
          result = output.compactMap { Lexicon.shared.foreignDictionary[$0] }
            .compactMap { $0 as? ForeignWord }
            .map { Rep.textWithTranslation(.init(text: $0.kana ?? "kana-miss",
                                                 language: .foreign,
                                                 translation: $0.english.randomElement()!.removingUniqueness()))}
        case .text(let language):
          switch language {
            case .english:
              result = output.map { Rep.textWithTranslation(.init(text: $0.removingUniqueness(),
                                                                  language: .english,
                                                                  translation: item(for: entry).written)) }
            case .foreign:
              result = output.compactMap { Lexicon.shared.foreignDictionary[$0] }
                .compactMap { $0 as? ForeignWord }
                .map { Rep.textWithFurigana(.init(text: $0.written.map { String($0) },
                                                  furigana: $0.kanaComponents,
                                                  english: $0.english.first!)) }
          }
        case .voice(let language):
          switch language {
            case .english:
              result = output.map { Rep.voice(.init(text: $0.removingUniqueness(), language: .english)) }
            case .foreign:
              result = output.compactMap { Lexicon.shared.foreignDictionary[$0] }
                .map { Rep.voice(.init(text: $0.written, language: .foreign)) }
          }
      }
    }
    
    guard result.count == 6 else {
      fatalError("There should be exactly 6 output representations.")
    }
    
    return result
  }
}
