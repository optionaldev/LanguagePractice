//
// The LanguagePractice project.
// Created by optionaldev on 08/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import class Foundation.DispatchQueue
import class Foundation.NumberFormatter

import protocol Foundation.ObservableObject

import struct Foundation.Date
import struct Foundation.Published
import struct Foundation.TimeInterval


final class PickQuizViewModel: OutputQuizable, ObservableObject, SpeechDelegate {
    
    private(set) var challengeMeasurement = ChallengeMeasurement()
    
    @Published var visibleChallenges: [PickChallenge] = []
    
    @Published private(set) var itemsLearned: [LearnedItem] = []
    
    private(set) var challengeEntries: [EntryProtocol]
    
    var nextChallenge: PickChallenge? = nil
    
    init(entryType: EntryType) {
        challengeEntries = EntryProvider.generate(entryType)
        performInitialSetup()
        
        Speech.shared.delegate = self
    }
    
    var voiceLastTappedIndex: Int = -1
    
    func finishedCurrentChallenge() {
        if visibleChallenges[visibleChallenges.count - 1].state != .guessedIncorrectly {
            let challengeTime = challengeMeasurement.stopAndFetchResult()
            visibleChallenges[visibleChallenges.count - 1].state = .finished(challengeTime)
        }
    }
    
    func prepareNextChallenge() {
        nextChallenge = ChallengeProvider.generatePick(for: challengeEntries[visibleChallenges.count], allEntries: challengeEntries)
    }
    
    func handleFinish() {
        var guessHistory: [String: [TimeInterval]] = Defaults.guessHistory
        
        for (index, challenge) in visibleChallenges.enumerated() {
            // History is recorded based on the foreign word ID, because that's what is being learned
            let id = challengeEntries[index].foreignID
            
            if let value = challenge.state?.storeValue {
                if guessHistory[id] == nil {
                    guessHistory[id] = [value]
                } else {
                    guessHistory[id]?.append(value)
                }
            } else {
                fatalError("Should never end without a state for every challenge")
            }
        }
        
        // In order to prevent showing items learned for items that have been learned in the past
        // but have made their way into the challenge because we didn't have enough non-learned
        // items to fulfill the minimum requirement of AppConstants.challengeInitialSampleSize,
        // we let the first `for` complete and do another one for newly learned items
        
        log("Guess history:")
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        _ = guessHistory.map { print("\($0.key) \($0.value.compactMap { numberFormatter.string(for: $0) }.joined(separator: " "))") }
        
        let knownItemsBeforeChallenge = Set(Defaults.knownForeignItemIDs)
        Defaults.set(guessHistory, forKey: .guessHistory)
        let knownItemsNow = Set(Defaults.knownForeignItemIDs)
        
        let newlyLearnedItemIDs = knownItemsNow.subtracting(knownItemsBeforeChallenge)
        
        if newlyLearnedItemIDs.isEmpty {
            fatalError("wait just a minute pal")
        }
        
        itemsLearned = newlyLearnedItemIDs.map { LearnedItem(id: $0, time: guessHistory[$0]!.challengeAverage) }
    }
    
    // MARK: - SpeechDelegate conformance
    
    func speechEnded() {
        if case .voice = currentChallenge.inputType {
            challengeMeasurement.start()
        } else if case .voice = currentChallenge.outputType,
                  currentChallenge.correctAnswerIndex == voiceLastTappedIndex
        {
            challengeMeasurement.start()
        }
    }
}

//final class PickQuizViewModel: ObservableObject {
//
//    /** Holds all the challenge that have been completed */
//    @Published private(set) var history: [PickChallenge] = []
//
//    // Populated at the end of the challenge
//    // Used to display words that were considered "learned", based on different metrics
//    @Published private(set) var wordsLearned: [String] = []
//
//    var currentWord: PickChallenge {
//        // TODO: Maybe implement a non-empty array to prevent force unwrap?
//        return history.last!
//    }
//
//    init() {
//        guard let lexicon = Defaults.lexicon else {
//            fatalError("Shouldn't allow creation of view model without lexicon existing")
//        }
//        self.lexicon = lexicon
//
//        let knownWords = Defaults.knownWords
//
//        // We want to avoid including words that were already deemed as "learned"
//        let shuffledForeignWords = lexicon.foreign.nouns.shuffled()
//
//        // prefix(10) doesn't crash if there's less than 10 elements in the array
//        var challengeWords = shuffledForeignWords.filter { !knownWords.contains($0.id) }
//            .prefix(10)
//
//        log("Learning: \(challengeWords.map { $0.id }.joined(separator: " "))")
//
//        // Handle case when there are less than 10 words left to learn
//        if challengeWords.count < AppConstants.challengeInitialSampleSize {
//            let extraWords = shuffledForeignWords.filter { knownWords.contains($0.id) }
//                .prefix(AppConstants.challengeInitialSampleSize - challengeWords.count)
//
//            challengeWords.append(contentsOf: extraWords)
//
//            log("and rehearsing: \(extraWords.map { $0.id }.joined(separator: " "))")
//        }
//
//        guard challengeWords.count == AppConstants.challengeInitialSampleSize else {
//            fatalError("Invalid number of elements")
//        }
//
//        // Method is declared here to be able to have a fully known 'challengeEntries' as a constant
//        func extract(_ foreignNoun: ForeignNoun) -> [Entry] {
//            var result = foreignNoun.english.flatMap {
//                [Entry(from: .english, to: .foreign, input: $0,             output: foreignNoun.id),
//                 Entry(from: .foreign, to: .english, input: foreignNoun.id, output: $0)]
//            }
//
//            if foreignNoun.kana != nil {
//                // For input, we could show multiple english translations, but for output only 1,
//                // so for now, display only the first and keep DB with first english translation
//                // being the most accurate one
//                guard let translation = foreignNoun.english.first else {
//                    log("No english translation found for foreign word with ID \"\(foreignNoun.id)\"", type: .unexpected)
//                    return result
//                }
//
//                result.append(Entry(from: .foreign, to: .foreign, input: foreignNoun.id, output: translation))
//            }
//            return result
//        }
//
//        challengeEntries = challengeWords.flatMap { extract($0) }.shuffled()
//        prepareNextChallenge()
//
//        guard nextChallenge != nil else {
//            log("no next challenge", type: .unexpected)
//            return
//        }
//        informView()
//        prepareNextChallenge()
//    }
//
//    func chose(index: Int) {
//        switch currentWord.outputRepresentations[index] {
//        case .voice(let rep):
//            // When voice is the output type of the challenge, the user first has to tap on the
//            // output button to hear the answer and tap the same output button again to choose
//            // that answer, so we always remember what the last pressed button was
//            if voiceLastTappedIndex == index && currentWord.correctAnswerIndex == index {
//                goToNext()
//                voiceLastTappedIndex = -1
//            } else {
//                voiceLastTappedIndex = index
//                Speech.shared.speak(string: rep.text, language: rep.language)
//            }
//        default:
//            if currentWord.correctAnswerIndex == index {
//                goToNext()
//            } else {
//                history[history.count - 1].state = .guessedIncorrectly
//            }
//        }
//    }
//
//    func inputTapped() {
//        if case .voice(let rep) = currentWord.inputRepresentation {
//            Speech.shared.speak(string: rep.text, language: rep.language)
//        }
//    }
//
//    // MARK: - Private
//
//    private let challengeEntries: [Entry]
//
//    // Declared as var due to it having mutating generated dictionaries
//    private var lexicon: Lexicon
//
//    // After processing the initial challenge that is immediately displayed to the user, we also prepare the next challenge
//    // Challenge preparation should be done off the main queue. Processing isn't very resources expensive, but might become one day
//    private var nextChallenge: PickChallenge?
//
//    // Keep the index of the last selected option in order to know when the user presses the button twice
//    // First tap on the output button means that the user wants to know what the output is
//    // Second tap on the output button means that the user chooses this answer
//    // Is initially -1 and it resets after every challenge, due to 0 representing the first index
//    // Valid values on second tap, depending on challenge size, is either 0...3 or 0...5
//    private var voiceLastTappedIndex: Int = -1
//
//    private func prepareNextChallenge() {
//        guard history.count < challengeEntries.count else {
//            log("Nothing to prepare", type: .info)
//            return
//        }
//
//        let nextEntry = challengeEntries[history.count]
//
//        guard let nextForeignWord = lexicon.foreignDictionary[nextEntry.foreign] else {
//            log("No foreign word with ID = \"\(nextEntry.foreign)\" found in dictionary", type: .unexpected)
//            return
//        }
//
//        let inputType  = generateInputType(for: nextEntry)
//        let input      = generateInput(for: nextEntry, inputType: inputType)
//        let inputRep   = generateInputRep(for: nextEntry, inputType: inputType, input: input, word: nextForeignWord)
//
//        let outputType = generateOutputType(for: nextEntry, inputType: inputType)
//        var output     = generateOutput(for: nextEntry, outputType: outputType)
//
//        let answerOutput: String
//        // Handle the case where output is already kana in nextEntry for simplified case
//        if nextEntry.to == .english {
//            answerOutput = nextEntry.output
//        } else if nextEntry.from == .foreign && nextEntry.to == .foreign {
//            answerOutput = nextEntry.input
//        } else {
//            answerOutput = lexicon.foreignDictionary[nextEntry.output]?.id ?? ""
//        }
//        output.append(answerOutput)
//        output.shuffle()
//
//        let outputRep = generateOutputRep(outputType: outputType, output: output, word: nextForeignWord)
//        let correctAnswerIndex = output.firstIndex(of: answerOutput)!
//
//        nextChallenge = PickChallenge(inputType: inputType,
//                                      input: input,
//                                      outputType: outputType,
//                                      output: output,
//                                      correctAnswerIndex: correctAnswerIndex,
//                                      inputRepresentations: inputRep,
//                                      outputRepresentations: outputRep)
//    }
//
//    private func informView() {
//        if let nextChallenge = nextChallenge {
//            history.append(nextChallenge)
//        } else {
//            // Challenge finished!
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
//        }
//
//        // At this point, we've already appended the `nextChallenge` to the `history` array
//        nextChallenge = nil
//    }
//
//    private func goToNext() {
//        finishedCurrentChallenge()
//        informView()
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.prepareNextChallenge()
//        }
//    }
//
//    private var endTimeOfPreviousChallenge = Date()
//
//    private func finishedCurrentChallenge() {
//        let currentDate = Date()
//        if history[history.count - 1].state != .guessedIncorrectly {
//            let challengeTime = currentDate.timeIntervalSince(endTimeOfPreviousChallenge)
//            history[history.count - 1].state = .finished(challengeTime)
//        }
//        endTimeOfPreviousChallenge = currentDate
//    }
//
//    // MARK: Input
//
//    private func generateInputType(for entry: Entry) -> ChallengeType {
//        var inputTypePossibilities = ChallengeType.allCases
//
//        if entry.from == .foreign && entry.to == .foreign {
//            return .simplified
//        } else {
//            // In case there's no images found, we can't create image based challenges
//            // For entries that don't have "from" as english, it doens't make sense to create an image based challenge
//            // We would just end up trying to guess if an image representing a concept matching an english word,
//            // which defeats the purpose of trying to learn a foreign word
//            if entry.noImage || entry.from != .english {
//                inputTypePossibilities.removing(.image)
//            }
//
//            if entry.english != nil {
//                inputTypePossibilities.removing(.simplified)
//            }
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
//    }
//
//    private func generateInput(for entry: Entry, inputType: ChallengeType) -> String {
//        if inputType == .text(.foreign) || inputType == .voice(.foreign) || inputType == .simplified {
//            guard let inputWord = lexicon.foreignDictionary[entry.input] else {
//                fatalError("Tried to fetch entry with ID \"\(entry.input)\" from foreign dictionary")
//            }
//
//            return inputWord.id
//        } else {
//            // For images and english input types, we simply use the input
//            return entry.input
//        }
//    }
//
//    private func generateInputRep(for entry: Entry, inputType: ChallengeType, input: String, word: ForeignWord) -> Rep {
//        switch inputType {
//        case .text(let language):
//            switch language {
//            case .english:
//                return .simpleText(.init(text: entry.input.removingDigits(),
//                                         language: .english))
//
//            case .foreign:
//                if word.hasKana {
//                    return .textWithFurigana(.init(text: word.characters.map { String($0) },
//                                                   furigana: word.kanaComponenets,
//                                                   english: entry.output.removingDigits()))
//                } else {
//                    return .simpleText(.init(text: word.characters,
//                                             language: .foreign))
//                }
//            }
//        case .voice(let language):
//            switch language {
//            case .english:
//                return .voice(.init(text: entry.input.removingDigits(),
//                                    language: .english))
//            case .foreign:
//                return .voice(.init(text: word.characters,
//                                    language: .foreign))
//            }
//        case .image:
//            return .image(.init(imageID: input))
//        case .simplified:
//            return .textWithTranslation(.init(text: word.characters,
//                                              language: .foreign,
//                                              translation: entry.output.removingDigits()))
//        }
//    }
//
//    // MARK: Output
//
//    private func generateOutputType(for entry: Entry, inputType: ChallengeType) -> ChallengeType {
//        var outputTypePossibilities: [ChallengeType]
//        switch inputType {
//        case .text(let language):
//            switch language {
//            case .english:
//                outputTypePossibilities = [.text(.foreign), .voice(.foreign)]
//
//            case .foreign:
//                outputTypePossibilities = [.text(.english), .image]
//            }
//        case .voice(let language):
//            switch language {
//            case .english:
//                outputTypePossibilities = [.text(.foreign), .voice(.foreign)]
//            case .foreign:
//                outputTypePossibilities = [.text(.english), .image /*TODO: draw kanji ?*/]
//            }
//        case .image:
//            outputTypePossibilities = [.text(.foreign), .voice(.foreign)]
//        case .simplified:
//            outputTypePossibilities = [.text(.foreign)]
//        }
//
//        if entry.english != nil {
//            outputTypePossibilities.removing(.simplified)
//        }
//
//        if entry.noImage {
//            outputTypePossibilities.removing(.image)
//        } else {
//            // TODO: handle not enough images downloaded so far
//        }
//
//        var outputType: ChallengeType
//        if inputType == .simplified {
//            outputType = .simplified
//        } else {
//            guard let randomOutputType = outputTypePossibilities.randomElement() else {
//                fatalError("Array is empty after filters are applied")
//            }
//            outputType = randomOutputType
//        }
//
//        return outputType
//    }
//
//    private func generateOutput(for entry: Entry, outputType: ChallengeType) -> [String] {
//        // Get a list of challenge
//        var otherSameTypeChallengeEntries = challengeEntries.filter { $0.type == entry.type &&
//                                                                      $0 != entry }
//        if let word = lexicon.foreignDictionary[entry.foreign] {
//            let other = otherSameTypeChallengeEntries.filter { $0.english == nil ||
//                                                              !word.english.contains($0.english!) }
//            otherSameTypeChallengeEntries = other
//        }
//
//        var output: [String]
//        switch outputType {
//        case .image:
//            // Get a list of all input, which in our scenario can only represent english IDs
////            let otherChallengeEntryIDs = otherSameTypeChallengeEntries.map { $0.output }
//            // TODO: Handle when current challenge doesn't countain 5 images
//            let otherChallengeEntryIDs = lexicon.english.nouns.map { $0.id }
//
//            // Get a list of all images available for current english IDs
//            output = otherChallengeEntryIDs.filter { Persistence.imagePath(id: $0) != nil }
//
//            output.removing(entry.english!)
//
//            // TODO: Handle picking images from other entries
//            log("Before filtering, found \(output.count) entries with images")
//
//            if output.count < 6 {
//                fatalError("Not enough images")
//            }
//
//        case .simplified:
//            output = otherSameTypeChallengeEntries.map { $0.input }
//
//        case .text(let language):
//            switch language {
//            case .english:
//                output = Array(otherSameTypeChallengeEntries.map { $0.output })
//            case .foreign:
//                let outputIDs = Array(otherSameTypeChallengeEntries.map { $0.output })
//                output = outputIDs.compactMap { lexicon.foreignDictionary[$0]?.id }
//            }
//
//        case .voice(let language):
//            switch language {
//            case .english:
//                output = Array(otherSameTypeChallengeEntries.map { $0.output })
//            case .foreign:
//                let outputIDs = Array(otherSameTypeChallengeEntries.map { $0.output })
//                output = outputIDs.compactMap { lexicon.foreignDictionary[$0]?.id }
//            }
//        }
//
//        output = Array(output.removingDuplicates().prefix(5))
//
//        guard output.count == 5 else {
//            fatalError("`output` should have exactly 5 entries")
//        }
//
//        return output
//    }
//
//    func generateOutputRep(outputType: ChallengeType, output: [String], word: ForeignWord) -> [Rep] {
//        let result: [Rep]
//
//        switch outputType {
//        case .image:
//            result = output.map { Rep.image(.init(imageID: $0)) }
//        case .simplified:
//            result = output.compactMap { lexicon.foreignDictionary[$0] }
//                .map { Rep.textWithTranslation(.init(text: $0.kana ?? "kana-miss",
//                                                     language: .foreign,
//                                                     translation: $0.english.randomElement()!.removingDigits()))}
//        case .text(let language):
//            switch language {
//            case .english:
//                result = output.map { Rep.textWithTranslation(.init(text: $0.removingDigits(),
//                                                                    language: .english,
//                                                                    translation: word.characters)) }
//            case .foreign:
//                result = output.compactMap { lexicon.foreignDictionary[$0] }
//                    .map { Rep.textWithFurigana(.init(text: $0.characters.map { String($0) },
//                                                      furigana: $0.kanaComponenets,
//                                                      english: $0.english.first!)) }
//            }
//        case .voice(let language):
//            switch language {
//            case .english:
//                result = output.map { Rep.voice(.init(text: $0.removingDigits(), language: .english)) }
//            case .foreign:
//                result = output.compactMap { lexicon.foreignDictionary[$0] }
//                    .map { Rep.voice(.init(text: $0.characters, language: .foreign)) }
//            }
//        }
//
//        guard result.count == 6 else {
//            fatalError("There should be exactly 6 output representations.")
//        }
//
//        return result
//    }
//}
