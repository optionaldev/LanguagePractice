//
// The LanguagePractice project.
// Created by optionaldev on 17/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

final class WordChallengeProvider: ChallengeProvidable {
  
  init(lexicon: Lexicon = .shared, speech: Speech = .shared) {
    self.lexicon = lexicon
    self.speech = speech
  }
  
  // MARK: - ChallengeProvidable conformance
  
  func generateTyping(fromPool pool: [Distinguishable], index: Int) -> TypingChallenge {
    fatalError()
  }
  
  func generatePick(fromPool pool: [Distinguishable], index: Int) -> PickChallenge {
    let pool = pool.compactMap { $0 as? WordEntry }
    let entry = pool[index]
    
    guard let foreignWord = lexicon.foreignDictionary[entry.id] as? ForeignWord else {
      fatalError("Couldn't find word with id: \"\(entry.id)\"")
    }
    
    let englishWord = randomEnglishWord(forForeignWordId: foreignWord.id)
    
    // TODO: Improve
    let voiceEnabled = speech.voicePossible(forEntry: entry)
    
    var inputTypePossibilities: [Possibility] = [.text]
    var outputTypePossibilities: [Possibility] = [.text]
    
    if voiceEnabled {
      inputTypePossibilities.append(.voice)
      outputTypePossibilities.append(.voice)
    }
    
    let otherItems: [Item] = pool
      .compactMap { item in
        switch entry.category {
          case .foreign:
            let englishIds: [String] = (lexicon.foreignDictionary[item.id] as? ForeignWord)?.english ?? []
            let oneEnglishId = englishIds.randomElement()!
            return lexicon.englishDictionary[oneEnglishId]
          case .english:
            return lexicon.foreignDictionary[item.id]
        }
      }
      .filter { $0.id != foreignWord.id }
    
    // We need unique values since there's multiple entries with same id,
    // but what differentiates them is the combination of id and category
    var uniqueItems: [Item] = []
    for (_, item) in otherItems.enumerated() {
      if uniqueItems.contains(where: { $0.id == item.id }) == false {
        uniqueItems.append(item)
      }
    }
    
    let idsWithImages = uniqueItems
      .compactMap { $0 as? ForeignWord }
      .flatMap { $0.englishImages }
    
    let po = uniqueItems.filter { $0.id != entry.id }.output
    
    switch entry.category {
      case .english:
        if foreignWord.englishImages.isNonEmpty {
          inputTypePossibilities.append(.image)
        }
      case .foreign:
        if idsWithImages.count >= Defaults.outputCount - 1 {
          outputTypePossibilities.append(.image)
        }
    }
    
    let inputType = inputTypePossibilities.randomElement()!
    let outputType = inputTypePossibilities.randomElement()!
    
    let input: InputRepresentation
    var output: [OutputRepresentation]
    var correctOutput: OutputRepresentation
    
    switch inputType {
      case .image:
        input = .image(foreignWord.englishImages.shuffled()[0])
      case .voice:
        switch entry.category {
          case .english:
            input = .voice(.init(first: englishWord.spoken))
          case .foreign:
            input = .voice(.init(first: foreignWord.spoken))
        }
      case .text:
        switch entry.category {
          case .english:
            input = .text(englishWord.written)
          case .foreign:
            input = generateTextualRepresentation(forWord: foreignWord)
        }
    }
    
    switch outputType {
      case .image:
        output = idsWithImages.output.map { OutputRepresentation.image($0) }
        correctOutput = .image(foreignWord.englishImages.shuffled()[0])
      case .text:
        output = irrespectiveOfImagesOtherWords.map { generateTextualRepresentation(forWord: $0) }
        switch entry.category {
          case .english:
            correctOutput = generateTextualRepresentation(forWord: foreignWord)
          case .foreign:
            correctOutput = .text(englishWord.written)
        }
      case .voice:
        output = irrespectiveOfImagesOtherWords.map { .voice($0.spoken) }
        switch entry.category {
          case .english:
            correctOutput = .voice(foreignWord.spoken)
          case .foreign:
            correctOutput = .voice(englishWord.spoken)
        }
    }
    
    output.append(correctOutput)
    
    guard let correctAnswerIndex = output.firstIndex(where: { $0.description == correctOutput.description }) else {
      fatalError("Couldn't find correct answer in list of answers.")
    }
    
    return PickChallenge(inputRep: input, outputRep: output, correctAnswerIndex: correctAnswerIndex)
  }
  
  // MARK: - Private
  
  private let lexicon: Lexicon
  private let speech: Speech
  
  // The next two functions are identical except for return type. Is it somehow possible to unity them into one?
  private func generateTextualRepresentation(forWord item: Item) -> InputRepresentation {
    if let foreignWord = item as? ForeignWord,
       foreignWord.hasFurigana
    {
      let charactersArray = foreignWord.written.map { String($0) }
      let representation = FuriganaRep(text: charactersArray,
                                       groups: foreignWord.kanaComponents)
      if foreignWord.groupFurigana {
        return .textWithIrregularFurigana(representation)
      } else {
        return .textWithRegularFurigana(representation)
      }
    } else {
      return .text(item.written)
    }
  }
  
  private func generateTextualRepresentation(forWord item: Item) -> OutputRepresentation {
    if let foreignWord = item as? ForeignWord,
       foreignWord.hasFurigana
    {
      let charactersArray = foreignWord.written.map { String($0) }
      let representation = FuriganaRep(text: charactersArray,
                                       groups: foreignWord.kanaComponents)
      if foreignWord.groupFurigana {
        return .textWithIrregularFurigana(representation)
      } else {
        return .textWithRegularFurigana(representation)
      }
    } else {
      return .text(item.written)
    }
  }
  
  func randomEnglishWord(forForeignWordId foreignId: String) -> EnglishItem {
    guard let foreignWord = lexicon.foreignDictionary[foreignId] as? ForeignWord else {
      fatalError()
    }
    guard let randomEnglishId = foreignWord.english.randomElement() else {
      fatalError()
    }
    guard let englishItem = lexicon.englishDictionary[randomEnglishId] else {
      fatalError()
    }
    return englishItem
  }
}
