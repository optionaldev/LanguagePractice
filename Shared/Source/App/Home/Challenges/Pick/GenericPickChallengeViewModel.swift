//
// The LanguagePractice project.
// Created by optionaldev on 05/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class Foundation.DispatchQueue
import class Foundation.NumberFormatter

import protocol Foundation.ObservableObject

import struct Foundation.Date
import struct Foundation.Published
import struct Foundation.TimeInterval


final class GenericPickChallengeViewModel<EntryT: EntryProtocol>: ViewModelProtocol {
    
    /** Holds all the challenge that have been completed */
    @Published private(set) var history: [PickChallenge] = []
    
    // Populated at the end of the challenge
    // Used to display words that were considered "learned", based on different metrics
    @Published private(set) var wordsLearned: [String] = []
    
    var currentWord: PickChallenge {
        // TODO: Maybe implement a non-empty array to prevent force unwrap?
        return history.last!
    }
    
    init(entries: [EntryT]) {
        challengeEntries = entries
        prepareNextChallenge()
        
        guard nextChallenge != nil else {
            log("no next challenge", type: .unexpected)
            return
        }
        informView()
        prepareNextChallenge()
    }
    
    func chose(index: Int) {
        switch currentWord.outputRepresentations[index] {
        case .voice(let rep):
            // When voice is the output type of the challenge, the user first has to tap on the
            // output button to hear the answer and tap the same output button again to choose
            // that answer, so we always remember what the last pressed button was
            if voiceLastTappedIndex == index && currentWord.correctAnswerIndex == index {
                goToNext()
                voiceLastTappedIndex = -1
            } else {
                voiceLastTappedIndex = index
                Speech.shared.speak(string: rep.text, language: rep.language)
            }
        default:
            if currentWord.correctAnswerIndex == index {
                goToNext()
            } else {
                history[history.count - 1].state = .guessedIncorrectly
            }
        }
    }
    
    func inputTapped() {
        if case .voice(let rep) = currentWord.inputRepresentation {
            Speech.shared.speak(string: rep.text, language: rep.language)
        }
    }
    
    // MARK: - Private
    
    private let challengeEntries: [EntryT]
    
    // Declared as var due to it having mutating generated dictionaries
    private var lexicon: Lexicon?
    
    // After processing the initial challenge that is immediately displayed to the user, we also prepare the next challenge
    // Challenge preparation should be done off the main queue. Processing isn't very resources expensive, but might become one day
    private var nextChallenge: PickChallenge?
    
    // Keep the index of the last selected option in order to know when the user presses the button twice
    // First tap on the output button means that the user wants to know what the output is
    // Second tap on the output button means that the user chooses this answer
    // Is initially -1 and it resets after every challenge, due to 0 representing the first index
    // Valid values on second tap, depending on challenge size, is either 0...3 or 0...5
    private var voiceLastTappedIndex: Int = -1
    
    private func prepareNextChallenge() {
        guard history.count < challengeEntries.count else {
            log("Nothing to prepare", type: .info)
            return
        }
        
        let nextEntry = challengeEntries[history.count]
        
        guard let nextForeignWord = lexicon?.foreignDictionary[nextEntry.foreignID] else {
            log("No foreign word with ID = \"\(nextEntry.foreignID)\" found in dictionary", type: .unexpected)
            return
        }
        
        let inputType  = generateInputType(for: nextEntry)
        let input      = generateInput(for: nextEntry, inputType: inputType)
        let inputRep   = generateInputRep(for: nextEntry, inputType: inputType, input: input, word: nextForeignWord)
        
        let outputType = generateOutputType(for: nextEntry, inputType: inputType)
        var output     = generateOutput(for: nextEntry, outputType: outputType)
        
        let answerOutput: String = nextEntry.output
        output.append(answerOutput)
        output.shuffle()
        
        let outputRep = generateOutputRep(outputType: outputType, output: output, word: nextForeignWord)
        let correctAnswerIndex = output.firstIndex(of: answerOutput)!
        
        nextChallenge = PickChallenge(inputType: inputType,
                                      input: input,
                                      outputType: outputType,
                                      output: output,
                                      correctAnswerIndex: correctAnswerIndex,
                                      inputRepresentations: inputRep,
                                      outputRepresentations: outputRep)
    }
    
    private func informView() {
        if let nextChallenge = nextChallenge {
            history.append(nextChallenge)
        } else {
            // Challenge finished!
            var guessHistory = Defaults.wordGuessHistory
            for entry in history {
                // History is recorded based on the foreign word ID, because that's what is being learned
                let id: String
                if lexicon?.foreignDictionary[entry.input] != nil {
                    id = entry.input
                } else {
                    id = entry.output[entry.correctAnswerIndex]
                }
                if case .guessedIncorrectly = entry.state {
                    if guessHistory[id] == nil {
                        guessHistory[id] = [-1]
                    } else {
                        guessHistory[id]?.append(-1)
                    }
                }
                if case .finished(let value) = entry.state {
                    if guessHistory[id] == nil {
                        guessHistory[id] = [value]
                    } else {
                        guessHistory[id]?.append(value)
                    }
                }
            }
            
            log("Guess history:")
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 1
            _ = guessHistory.map { print("\($0.key) \($0.value.compactMap { numberFormatter.string(for: $0) }.joined(separator: " "))") }
            
            let knownWordsBeforeChallenge = Defaults.knownWords
            Defaults.set(guessHistory, forKey: .wordGuessHistory)
            let knownWordsNow = Defaults.knownWords
            
            wordsLearned = knownWordsNow.filter { !knownWordsBeforeChallenge.contains($0) }
        }
        
        // At this point, we've already appended the `nextChallenge` to the `history` array
        nextChallenge = nil
    }
    
    private func goToNext() {
        finishedCurrentChallenge()
        informView()
        DispatchQueue.global(qos: .userInitiated).async {
            self.prepareNextChallenge()
        }
    }
    
    private var endTimeOfPreviousChallenge = Date()
    
    private func finishedCurrentChallenge() {
        let currentDate = Date()
        if history[history.count - 1].state != .guessedIncorrectly {
            let challengeTime = currentDate.timeIntervalSince(endTimeOfPreviousChallenge)
            history[history.count - 1].state = .finished(challengeTime)
        }
        endTimeOfPreviousChallenge = currentDate
    }
    
    // MARK: Input
    
    private func generateInputType(for entry: EntryT) -> ChallengeType {
        var inputTypePossibilities = ChallengeType.allCases
        
        if entry.inputLanguage == .foreign && entry.outputLanguage == .foreign {
            return .simplified
        } else {
            // In case there's no images found, we can't create image based challenges
            // For entries that don't have "from" as english, it doens't make sense to create an image based challenge
            // We would just end up trying to guess if an image representing a concept matching an english word,
            // which defeats the purpose of trying to learn a foreign word
            if entry.noImage || entry.inputLanguage != .english {
                inputTypePossibilities.removing(.image)
            }
            
            if entry.inputLanguage == .english || entry.outputLanguage == .english {
                inputTypePossibilities.removing(.simplified)
            }
            
            // `entry.to` represents the output type, but here we're trying to generate the input type
            // and aside from simplified challenge, input & output are never the same language
            inputTypePossibilities.removing(.voice(entry.outputLanguage))
            inputTypePossibilities.removing(.text(entry.outputLanguage))
            
            guard let randomInputType = inputTypePossibilities.randomElement() else {
                fatalError("Array should never be empty after applying filters")
            }
            return randomInputType
        }
    }
    
    private func generateInput(for entry: EntryT, inputType: ChallengeType) -> String {
        if inputType == .text(.foreign) || inputType == .voice(.foreign) || inputType == .simplified {
            guard let inputWord = lexicon?.foreignDictionary[entry.input] else {
                fatalError("Tried to fetch entry with ID \"\(entry.input)\" from foreign dictionary")
            }
            
            return inputWord.id
        } else {
            // For images and english input types, we simply use the input
            return entry.input
        }
    }
    
    private func generateInputRep(for entry: EntryT, inputType: ChallengeType, input: String, word: ForeignWord) -> Rep {
        switch inputType {
        case .text(let language):
            switch language {
            case .english:
                return .simpleText(.init(text: entry.input.removingDigits(),
                                         language: .english))
                
            case .foreign:
                if word.hasKana {
                    return .textWithFurigana(.init(text: word.characters.map { String($0) },
                                                   furigana: word.kanaComponenets,
                                                   english: entry.output.removingDigits()))
                } else {
                    return .simpleText(.init(text: word.characters,
                                             language: .foreign))
                }
            }
        case .voice(let language):
            switch language {
            case .english:
                return .voice(.init(text: entry.input.removingDigits(),
                                    language: .english))
            case .foreign:
                return .voice(.init(text: word.characters,
                                    language: .foreign))
            }
        case .image:
            return .image(.init(imageID: input))
        case .simplified:
            return .textWithTranslation(.init(text: word.characters,
                                              language: .foreign,
                                              translation: entry.output.removingDigits()))
        }
    }
    
    // MARK: Output
    
    private func generateOutputType(for entry: EntryT, inputType: ChallengeType) -> ChallengeType {
        var outputTypePossibilities: [ChallengeType]
        switch inputType {
        case .text(let language):
            switch language {
            case .english:
                outputTypePossibilities = [.text(.foreign), .voice(.foreign)]
                
            case .foreign:
                outputTypePossibilities = [.text(.english), .image]
            }
        case .voice(let language):
            switch language {
            case .english:
                outputTypePossibilities = [.text(.foreign), .voice(.foreign)]
            case .foreign:
                outputTypePossibilities = [.text(.english), .image /*TODO: draw kanji ?*/]
            }
        case .image:
            outputTypePossibilities = [.text(.foreign), .voice(.foreign)]
        case .simplified:
            outputTypePossibilities = [.text(.foreign)]
        }
        
        if entry.inputLanguage == .english || entry.outputLanguage == .english {
            outputTypePossibilities.removing(.simplified)
        }
        
        if entry.noImage {
            outputTypePossibilities.removing(.image)
        } else {
            // TODO: handle not enough images downloaded so far
        }
        
        var outputType: ChallengeType
        if inputType == .simplified {
            outputType = .simplified
        } else {
            guard let randomOutputType = outputTypePossibilities.randomElement() else {
                fatalError("Array is empty after filters are applied")
            }
            outputType = randomOutputType
        }
        
        return outputType
    }
    
    private func generateOutput(for entry: EntryT, outputType: ChallengeType) -> [String] {
        // Get a list of challenge
        var otherSameTypeChallengeEntries = challengeEntries.filter { $0.sameType(as: entry) &&
                                                                      $0 != entry }
        if let word = lexicon?.foreignDictionary[entry.foreignID] {
            let other = otherSameTypeChallengeEntries.filter { $0.english == nil ||
                                                              !word.english.contains($0.english!) }
            otherSameTypeChallengeEntries = other
        }
        
        var output: [String]
        switch outputType {
        case .image:
            // Get a list of all input, which in our scenario can only represent english IDs
//            let otherChallengeEntryIDs = otherSameTypeChallengeEntries.map { $0.output }
            // TODO: Handle when current challenge doesn't countain 5 images
            guard let otherChallengeEntryIDs = lexicon?.english.nouns.map({ $0.id }) else {
                fatalError("lexicon not available here?")
            }
            
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
                output = outputIDs.compactMap { lexicon?.foreignDictionary[$0]?.id }
            }
            
        case .voice(let language):
            switch language {
            case .english:
                output = Array(otherSameTypeChallengeEntries.map { $0.output })
            case .foreign:
                let outputIDs = Array(otherSameTypeChallengeEntries.map { $0.output })
                output = outputIDs.compactMap { lexicon?.foreignDictionary[$0]?.id }
            }
        }
        
        output = Array(output.removingDuplicates().prefix(5))
        
        guard output.count == 5 else {
            fatalError("`output` should have exactly 5 entries")
        }
        
        return output
    }
    
    func generateOutputRep(outputType: ChallengeType, output: [String], word: ForeignWord) -> [Rep] {
        let result: [Rep]
        
        switch outputType {
        case .image:
            result = output.map { Rep.image(.init(imageID: $0)) }
        case .simplified:
            result = output.compactMap { lexicon?.foreignDictionary[$0] }
                .map { Rep.textWithTranslation(.init(text: $0.kana ?? "kana-miss",
                                                     language: .foreign,
                                                     translation: $0.english.randomElement()!.removingDigits()))}
        case .text(let language):
            switch language {
            case .english:
                result = output.map { Rep.textWithTranslation(.init(text: $0.removingDigits(),
                                                                    language: .english,
                                                                    translation: word.characters)) }
            case .foreign:
                result = output.compactMap { lexicon?.foreignDictionary[$0] }
                    .map { Rep.textWithFurigana(.init(text: $0.characters.map { String($0) },
                                                      furigana: $0.kanaComponenets,
                                                      english: $0.english.first!)) }
            }
        case .voice(let language):
            switch language {
            case .english:
                result = output.map { Rep.voice(.init(text: $0.removingDigits(), language: .english)) }
            case .foreign:
                result = output.compactMap { lexicon?.foreignDictionary[$0] }
                    .map { Rep.voice(.init(text: $0.characters, language: .foreign)) }
            }
        }
        
        guard result.count == 6 else {
            fatalError("There should be exactly 6 output representations.")
        }
        
        return result
    }
}
