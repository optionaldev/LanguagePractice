//
// The LanguagePractice project.
// Created by optionaldev on 12/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

//enum WordPickEntry {
//  
//  case englishToForeign(Ids)
//  case foreignToEnglish(Ids)
//  case foreign(String)
//  
//  var input: String {
//    switch self {
//      case .englishToForeign(let ids):
//        return ids.english
//      case .foreignToEnglish(let ids):
//        return ids.foreign
//      case .foreign(let text):
//        return text
//    }
//  }
//  
//  var inputPossibilities: [ChallengeType2] {
//    var possibilities: [ChallengeType2]
//    switch self {
//      case .englishToForeign(let ids):
//        possibilities = [.text, .voice, .image]
//        if Persistence.imagePath(id: ids.english) == nil {
//          possibilities.removing(.image)
//        }
//      case .foreignToEnglish:
//        possibilities = [.text, .voice]
//      case .foreign:
//        possibilities = [.text]
//    }
//    
//    if !Defaults.voiceEnabled {
//      possibilities.removing(.voice)
//    }
//    
//    return possibilities
//  }
//  
//  var english: String? {
//    switch self {
//      case .englishToForeign(let ids):
//        return ids.english
//      case .foreignToEnglish(let ids):
//        return ids.english
//      case .foreign:
//        return nil
//    }
//  }
//  
//  var foreign: String {
//    switch self {
//      case .englishToForeign(let ids):
//        return ids.foreign
//      case .foreignToEnglish(let ids):
//        return ids.foreign
//      case .foreign(let foreign):
//        return foreign
//    }
//  }
//  
//  var inputLanguage: Language {
//    switch self {
//      case .englishToForeign:
//        return .english
//      case .foreignToEnglish, .foreign:
//        return .foreign
//    }
//  }
//}
//
//class BaseEntryProvider {
//  
//  func generateUnknown(source: [String], for type: KnowledgeType) -> [String] {
//    let knownItems = Defaults.knownIds(for: type)
//    
//    // We fetch all items that are yet to be learned & shuffle to prevent repetitiveness
//    var unknownItems = Array(source
//                              .filter { !knownItems.contains($0) }
//                             // TODO: Decide on whether we should shuffle or have a lexicon predefined order based on certain criteria
//                             //                              .shuffled()
//                              .prefix(AppConstants.challengeInitialSampleSize))
//    
//    // We handle the case where there are less than 10 items left to learn
//    if unknownItems.count < AppConstants.challengeInitialSampleSize {
//      let extraItems = source.filter { knownItems.contains($0) }
//        .prefix(AppConstants.challengeInitialSampleSize - unknownItems.count)
//      
//      unknownItems.append(contentsOf: extraItems)
//    }
//    
//    guard unknownItems.count == AppConstants.challengeInitialSampleSize else {
//      fatalError("Invalid number of elements")
//    }
//    
//    return unknownItems
//  }
//}
//
//final class WordPickEntryProvider: BaseEntryProvider {
//  
//  init(lexicon: Lexicon) {
//    self.lexicon = lexicon
//  }
//  
//  func generate() -> [WordPickEntry] {
//    let itemsOfInterest = lexicon.foreign.all.map { $0.id }
//    let unknownItems = generateUnknown(source: itemsOfInterest, for: .picking)
//    let result = unknownItems.flatMap { entries(forId: $0) }
//    return result
//  }
//  
//  // MARK: - Private
//  
//  private let lexicon: Lexicon
//  
//  private func entries(forId id: String) -> [WordPickEntry] {
//    guard let foreignWord = lexicon.foreignDictionary[id] as? ForeignWord else {
//      log("Unable to fetch and cast item with id \"\(id)\".")
//      return []
//    }
//    
//    return foreignWord.english.flatMap {
//      [WordPickEntry.englishToForeign(.init(english: $0, foreign: foreignWord.id)),
//       WordPickEntry.foreignToEnglish(.init(english: $0, foreign: foreignWord.id)),
//       WordPickEntry.foreign(foreignWord.id)]
//    }
//  }
//}
//
//struct WordPickChallenge {
//  
//  let inputRep: Repet
//  let outputRep: Repet
//  let output: [String]
//  let correctAnswerIndex: Int
//}
//
//struct FuriganaRepet {
//  
//  let text: [String]
//  let furigana: [String]
//}
//
//struct TranslationRepet {
//  
//  let text: String
//  let translation: String
//}
//
//enum Repet {
//  
//  case text(String)
//  case textWithTranslation(TranslationRepet)
//  case textWithFurigana(FuriganaRepet)
//  case image(String)
//  case voice(String)
//}
//
//enum ChallengeType2 {
//  
//  case text
//  case image
//  case voice
//}
//
//class BaseChallengeProvider {
//  
//  init(lexicon: Lexicon) {
//    self.lexicon = lexicon
//  }
//  
//  func generateInputComponents(forEntry entry: WordPickEntry) -> (ChallengeType2, Repet) {
//    guard let inputType = entry.inputPossibilities.randomElement() else {
//      fatalError("Situation where there's no possibilites? How does that happen?")
//    }
//    
//    let inputRep: Repet
//    guard let foreignWord = lexicon.foreignDictionary[entry.foreign] as? ForeignWord else {
//      fatalError("Created entry for non-existing word")
//    }
//    
//    switch inputType {
//      case .text:
//        switch entry.inputLanguage {
//          case .english:
//            guard let english = entry.english else {
//              fatalError("Should always have english property for english as inputLanguage")
//            }
//            inputRep = .text(english)
//          case .foreign:
//            if foreignWord.hasFurigana {
//              let text = foreignWord.groupFurigana ? [foreignWord.written] : foreignWord.written.map { String($0) }
//              inputRep = .textWithFurigana(.init(text: text,
//                                                 furigana: foreignWord.kanaComponenets))
//            } else {
//              inputRep = .text(entry.foreign)
//            }
//        }
//      case .voice:
//        inputRep = .voice(entry.input)
//      case .image:
//        guard let english = entry.english else {
//          fatalError("Looked for image, but image can't exist")
//        }
//        
//        inputRep = .image(english)
//    }
//    
//    return (inputType, inputRep)
//  }
//  
//  func generateOutputType(forEntry entry: WordPickEntry, inputType: ChallengeType2) -> ChallengeType2 {
//    
//    // TODO: implement generate output
//    return .voice
//  }
//  
//  // MARK: - Private
//  
//  let lexicon: Lexicon
//  
//  private static func generateInputType(forEntry entry: EntryProtocol) -> ChallengeType {
//    var inputTypePossibilities = entry.inputPossibilities
//    
//    // In case there's no images found, we can't create image based challenges
//    // For entries that don't have "from" as english, it doens't make sense to create an image based challenge
//    // We would just end up trying to guess if an image representing a concept matching an english word,
//    // which defeats the purpose of trying to learn a foreign word
//    if entry.noImage || entry.inputLanguage != .english {
//      inputTypePossibilities.removing(.image)
//    }
//    
//    if entry is WordEntry {
//      if entry.inputLanguage == entry.outputLanguage {
//        return .simplified
//      } else {
//        inputTypePossibilities.removing(.simplified)
//        
//        // `entry.to` represents the output type, but here we're trying to generate the input type
//        // and aside from simplified challenge, input & output are never the same language
//        inputTypePossibilities.removing(.voice(entry.outputLanguage))
//        inputTypePossibilities.removing(.text(entry.outputLanguage))
//      }
//    }
//    
//    guard let randomInputType = inputTypePossibilities.randomElement() else {
//      fatalError("Array should never be empty after applying filters")
//    }
//    
//    return randomInputType
//  }
//}
//
//final class WordPickChallengeProvider: BaseChallengeProvider {
//  
//  func generate(forEntries entries: [WordPickEntry]) -> [WordPickChallenge] {
//
//    // TODO: implement generate method
//    return []
//  }
//  
//  // MARK: - Private
//  
//  private func generate(forEntry entry: WordPickEntry) -> WordPickChallenge {
//    let (inputType, inputRep) = generateInputComponents(forEntry: entry)
//    let outputType = generateOutputType(forEntry: entry, inputType: inputType)
//    let outputRep = generateOutputRep(forEntry: entry, outputType: outputType)
////    let output =
//    
//    return WordPickChallenge(inputRep: inputRep,
//                             outputRep: outputRep,
//                             output: [],
//                             correctAnswerIndex: <#T##Int#>)
//  }
//  
//  private func generateOutputRep(forEntry entry: WordPickEntry, outputType: ChallengeType2) -> Repet {
//    guard let foreignWord = lexicon.foreignDictionary[entry.foreign] as? ForeignWord else {
//      fatalError("Couldn't find foreign word for key \"\(entry.foreign)\"")
//    }
//    
//    switch outputType {
//      case .text:
//        if entry.inputLanguage == .foreign {
//          return .text
//        } else {
//          if case .foreign = entry {
//            
//          }
//        }
//      case .image:
//        
//      case .voice:
//        
//    }
//  }
//}
