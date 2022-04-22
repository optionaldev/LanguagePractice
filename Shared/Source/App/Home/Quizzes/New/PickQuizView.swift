//
// The LanguagePractice project.
// Created by optionaldev on 21/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

import Dispatch

import protocol SwiftUI.View

import struct SwiftUI.AppStorage
import struct SwiftUI.Button
import struct SwiftUI.CGFloat
import struct SwiftUI.Color
import struct SwiftUI.Font
import struct SwiftUI.ForEach
import struct SwiftUI.HStack
import struct SwiftUI.Image
import struct SwiftUI.Text
import struct SwiftUI.ObservedObject
import struct SwiftUI.PlainButtonStyle
import struct SwiftUI.Rectangle
import struct SwiftUI.VStack
import struct SwiftUI.ViewBuilder
import SwiftUI


struct PickQuizView: View {
  
  init(entryType: EntryType, lexicon: Lexicon = .shared, speech: Speech = .shared) {
    switch entryType {
      case .hiragana:
        viewModel = PickQuizViewModel(entryProvider: HiraganaEntryProvider(lexicon: lexicon),
                                      challengeProvider: KanaPickChallengeProvider(lexicon: lexicon),
                                      resultsInterpreter: KanaResultsInterpreter(lexicon: lexicon))
      case .katakana:
        viewModel = PickQuizViewModel(entryProvider: KatakanaEntryProvider(lexicon: lexicon),
                                      challengeProvider: KanaPickChallengeProvider(lexicon: lexicon),
                                      resultsInterpreter: KanaResultsInterpreter(lexicon: lexicon))
      case .words:
        viewModel = PickQuizViewModel(entryProvider: WordEntryProvider(lexicon: lexicon),
                                      challengeProvider: WordChallengeProvider(lexicon: lexicon, speech: speech),
                                      resultsInterpreter: WordResultsInterpreter(lexicon: lexicon))
      case .conjugateVerbs:
        viewModel = PickQuizViewModel(entryProvider: ConjugatableVerbsEntryProvider(),
                                      challengeProvider: VerbConjugationsChallengeProvider(),
                                      resultsInterpreter: ConjugatableResultsInterpreter())
      case .conjugateAdjectives:
        viewModel = PickQuizViewModel(entryProvider: ConjugatableAdjectiveEntryProvider(),
                                      challengeProvider: AdjectiveConjugationsChallengeProvider(),
                                      resultsInterpreter: ConjugatableResultsInterpreter())
        
    }
  }
  
  var body: some View {
    QuizBody(viewModel: viewModel) { challenge in
      challengeView(challenge: challenge)
    }
  }
  
  // MARK: - Private
  
  @ObservedObject private var viewModel: PickQuizViewModel
  
  @ViewBuilder
  private func challengeView(challenge: PickChallenge) -> some View {
    // TODO: Find a better way do macros with declarative statements
#if os(iOS)
    VStack {
      QuizViews.inputView(rep: challenge.inputRep, viewModel: viewModel)
        .frame(height: 200)
        .frame(maxWidth: Canvas.width - 10)
        .background(Color.orange.opacity(0.5))
        .cornerRadius(5)
      pickChallengeOutput(representations: challenge.outputRep)
        .frame(maxWidth: Canvas.width - 10, maxHeight: .infinity)
        .padding(0)
    }
    .frame(width: Canvas.width)
    .background(Color.green.opacity(0.3))
#else
    HStack {
      QuizViews.inputView(rep: challenge.inputRep, viewModel: viewModel)
        .frame(width: 390, height: 290)
        .background(Color.orange.opacity(0.5))
        .cornerRadius(5)
        .padding(5)
      pickChallengeOutput(representations: challenge.outputRep)
        .frame(width: 300, height: 300)
        .padding(0)
    }
    .background(Color.green.opacity(0.3))
#endif
  }
  
  // MARK: - Output
  
  private func pickChallengeOutput(representations: [OutputRepresentation]) -> some View {
    GridView(rows: 3, columns: 2) { index in
      Button {
        viewModel.chose(index: index)
      } label: {
        outputContent(forRepresentation: representations[index])
          .contentShape(Rectangle())
          .padding(0)
          .background(Color.blue.opacity(0.5))
          .cornerRadius(5)
      }
      .buttonStyle(PlainButtonStyle())
      .padding(5)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  @ViewBuilder
  private func outputContent(forRepresentation representation: OutputRepresentation) -> some View {
    switch representation {
      case .image(let rep):
        QuizViews.viewForImage(id: rep, signal: .output)
      case .voice:
        QuizViews.waveformImage
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .padding(10)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Color.blue.opacity(0.5))
          .cornerRadius(5)
      case .textWithTranslation(let rep):
        Text(rep.text)
          .fixedSize(horizontal: false, vertical: true)
          .multilineTextAlignment(.center)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .contentShape(Rectangle())
          .font(customFont(ofSize: 25))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Color.blue.opacity(0.5))
          .cornerRadius(5)
      case .textWithRegularFurigana(let rep):
        QuizViews.textWithFurigana(representation: rep, regular: true)
          .background(Color.blue.opacity(0.5))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .cornerRadius(5)
      case .textWithIrregularFurigana(let rep):
        QuizViews.textWithFurigana(representation: rep, regular: false)
          .background(Color.blue.opacity(0.5))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .cornerRadius(5)
      case .text(let rep):
        Text(rep)
          .multilineTextAlignment(.center)
          .font(customFont(ofSize: 20))
          .background(Color.blue.opacity(0.5))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .cornerRadius(5)
    }
  }
  
  func customFont(ofSize size: CGFloat) -> Font {
    if let fontName = kanjiFontName {
      print("custom font")
      return .custom(fontName, size: size)
    }
    print("system font")
    return .system(size: size)
  }
  
  @AppStorage(DefaultsStringKey.kanjiFontName.rawValue) var kanjiFontName: String?
}
