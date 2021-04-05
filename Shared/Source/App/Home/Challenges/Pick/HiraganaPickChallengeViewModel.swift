//
// The LanguagePractice project.
// Created by optionaldev on 03/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 


import class Foundation.DispatchQueue
import class Foundation.NumberFormatter

import protocol Foundation.ObservableObject

import struct Foundation.Date
import struct Foundation.Published
import struct Foundation.TimeInterval


final class HiraganaPickChallengeViewModel: ObservableObject {
    
    /** Holds all the challenge that have been completed */
    @Published private(set) var history: [PickChallenge] = []
    
    // Populated at the end of the challenge
    // Used to display words that were considered "learned", based on different metrics
    @Published private(set) var wordsLearned: [String] = []
    
    var currentWord: PickChallenge {
        // TODO: Maybe implement a non-empty array to prevent force unwrap?
        return history.last!
    }
    
    
    init() {
        let knownHiragana = Defaults.knownHiragana
        
        var challengeHiragana = Hiragana.all
            .filter { !knownHiragana.contains($0) }
            .shuffled()
            .prefix(AppConstants.challengeInitialSampleSize)
        
        log("Learning: \(challengeHiragana.map { $0.hiragana }.joined(separator: ", "))")
        
        
        
        // Handle case when there are less than 10 words left to learn
        if challengeHiragana.count < AppConstants.challengeInitialSampleSize {
            let extraHiragana = challengeHiragana.filter { knownHiragana.contains($0) }
                .prefix(AppConstants.challengeInitialSampleSize - challengeHiragana.count)
            
            challengeHiragana.append(contentsOf: extraHiragana)
            
            log("and rehearsing: \(extraHiragana.map { $0.hiragana }.joined(separator: " "))")
        }
        
        guard challengeHiragana.count == AppConstants.challengeInitialSampleSize else {
            fatalError("Invalid number of elements")
        }
        
        // Method is declared here to be able to have a fully known 'challengeEntries' as a constant
        func extract(_ foreignCharacter: ForeignCharacter) -> [Entry] {
            
            return [Entry(from: .english, to: .foreign, input: foreignCharacter.roman, output: foreignCharacter.hiragana),
                    Entry(from: .foreign, to: .english, input: foreignCharacter.hiragana, output: foreignCharacter.roman)]
        }
        
        challengeEntries = challengeHiragana.flatMap { extract($0) }.shuffled()
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
        case .image, .simpleText, .textWithFurigana, .textWithTranslation:
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
    
    private let challengeEntries: [Entry]
    
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
        
        let inputType  = generateInputType(for: nextEntry)
        let input      = generateInput(for: nextEntry, inputType: inputType)
        let inputRep   = generateInputRep(for: nextEntry, inputType: inputType, input: input)
        
        let outputType = generateOutputType(for: nextEntry, inputType: inputType)
        var output     = generateOutput(for: nextEntry, outputType: outputType)
        
        let answerOutput: String
        // Handle the case where output is already kana in nextEntry for simplified case
        switch nextEntry.to {
        case .english:
            guard let english = nextEntry.english else {
                fatalError("English output without english translation?")
            }
            log("answerOutput is english")
            answerOutput = english
        case .foreign:
            guard let foreign = ForeignCharacter(nextEntry.foreign)?.hiragana else {
                fatalError("Foreign output without convertible characters?")
            }
            log("answerOutput is foreign")
            answerOutput = foreign
        }
        output.append(answerOutput)
        output.shuffle()
        
        let outputRep = generateOutputRep(outputType: outputType, output: output)
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
            log("Entry = \(challengeEntries[history.count - 1])")
            print("Current challenge = \(nextChallenge)")
        } else {
            // Challenge finished!
//            var guessHistory = Defaults.wordGuessHistory
//            for entry in history {
//                // History is recorded based on the foreign word ID, because that's what is being learned
//                let id: String
//                if lexicon.foreignDictionary[entry.input] != nil {
//                    id = entry.input
//                } else {
//                    id = entry.output[entry.correctAnswerIndex]
//                }
//                if case .guessedIncorrectly = entry.state {
//                    if guessHistory[id] == nil {
//                        guessHistory[id] = [-1]
//                    } else {
//                        guessHistory[id]?.append(-1)
//                    }
//                }
//                if case .finished(let value) = entry.state {
//                    if guessHistory[id] == nil {
//                        guessHistory[id] = [value]
//                    } else {
//                        guessHistory[id]?.append(value)
//                    }
//                }
//            }
//
//            log("Guess history:")
//            let numberFormatter = NumberFormatter()
//            numberFormatter.maximumFractionDigits = 1
//            _ = guessHistory.map { print("\($0.key) \($0.value.compactMap { numberFormatter.string(for: $0) }.joined(separator: " "))") }
//
//            let knownWordsBeforeChallenge = Defaults.knownWords
//            Defaults.set(guessHistory, forKey: .wordGuessHistory)
//            let knownWordsNow = Defaults.knownWords
//
//            wordsLearned = knownWordsNow.filter { !knownWordsBeforeChallenge.contains($0) }
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
    
    private func generateInputType(for entry: Entry) -> ChallengeType {
        var inputTypePossibilities = ChallengeType.allCases
        
        inputTypePossibilities.removing(.image)
        inputTypePossibilities.removing(.simplified)
        inputTypePossibilities.removing(.voice(.english))
        
        guard let result = inputTypePossibilities.randomElement() else {
            fatalError("Couldn't extract result from \(inputTypePossibilities)")
        }
        
        return result
        
//        if entry.from == .foreign && entry.to == .foreign {
//            return .simplified
//        } else {
//            inputTypePossibilities.removing(.image)
//            inputTypePossibilities.removing(.voice(.english))
//
//            // `entry.to` represents the output type, but here we're trying to generate the input type
//            // and aside from simplified challenge, input & output are never the same language
//            inputTypePossibilities.removing(.voice(entry.to))
//            inputTypePossibilities.removing(.text(entry.to))
//
//            guard let randomInputType = inputTypePossibilities.randomElement() else {
//                fatalError("Array should never be empty after applying filters")
//            }
//            return randomInputType
//        }
    }
    
    private func generateInput(for entry: Entry, inputType: ChallengeType) -> String {
        if inputType == .text(.english) {
            guard let english = entry.english else {
                fatalError("Expected english for this type of challenge")
            }
            return english
        } else {
            return entry.foreign
        }
    }
    
    private func generateInputRep(for entry: Entry, inputType: ChallengeType, input: String) -> Rep {
        if inputType == .text(.english) {
            return .simpleText(.init(text: entry.input, language: .english))
        } else {
            guard let hiragana = ForeignCharacter(entry.input)?.hiragana else {
                fatalError("Tried to convert \(entry.input) to hiragana and failed")
            }
            
            if inputType == .text(.foreign) {
                return .simpleText(.init(text: hiragana, language: .foreign))
            } else {
                return .voice(.init(text: hiragana, language: .foreign))
            }
        }
    }
    
    // MARK: Output
    
    private func generateOutputType(for entry: Entry, inputType: ChallengeType) -> ChallengeType {
        var outputTypePossibilities: [ChallengeType]
        switch inputType {
        case .text(let language):
            switch language {
            case .english:
                outputTypePossibilities = [.text(.foreign), .voice(.foreign)]
            case .foreign:
                outputTypePossibilities = [.text(.english), .voice(.foreign)]
            }
        case .voice(let language):
            switch language {
            case .english:
                fatalError("Tried to generate output type .voice(.english), but should not be possible")
            case .foreign:
                outputTypePossibilities = [.text(.english), .text(.foreign) /*TODO: draw kanji ?*/]
            }
        case .image, .simplified:
            fatalError("Tried to generate output type .simplified or .image, but should not be possible")
        }
        
        guard let randomOutputType = outputTypePossibilities.randomElement() else {
            fatalError("Array is empty after filters are applied")
        }
        return randomOutputType
    }
    
    private func generateOutput(for entry: Entry, outputType: ChallengeType) -> [String] {
        
        var result: [String]
        // Get a list of challenge
        let otherSameTypeChallengeEntries = challengeEntries.filter { $0.type == entry.type &&
                                                                      $0 != entry }
        
        switch outputType {
        case .text(let language):
            switch language {
            case .english:
                result = otherSameTypeChallengeEntries.map { $0.output }
            case .foreign:
                result = otherSameTypeChallengeEntries.compactMap { $0.output }
            }
        case .voice(let language):
            switch language {
            case .english:
                fatalError("We don't want to read \"a\" with english voice")
            case .foreign:
                result = otherSameTypeChallengeEntries.map { $0.foreign }
                    .compactMap { ForeignCharacter($0)?.hiragana }
            }
        case .image, .simplified:
            fatalError("Not possible to have these output types")
        }
        
        result = Array(result.removingDuplicates().prefix(5))
        
        guard result.count == 5 else {
            fatalError("`output` should have exactly 5 entries")
        }
        
        return result
    }
    
    func generateOutputRep(outputType: ChallengeType, output: [String]) -> [Rep] {
        let result: [Rep]
        
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
        
        guard result.count == 6 else {
            fatalError("There should be exactly 6 output representations.")
        }
        
        return result
    }
}
