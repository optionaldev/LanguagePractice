//
// The LanguagePractice project.
// Created by optionaldev on 18/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import Dispatch

import protocol SwiftUI.View

import struct SwiftUI.Button
import struct SwiftUI.Color
import struct SwiftUI.ForEach
import struct SwiftUI.HStack
import struct SwiftUI.Image
import struct SwiftUI.Text
import struct SwiftUI.ObservedObject
import struct SwiftUI.PlainButtonStyle
import struct SwiftUI.Rectangle
import struct SwiftUI.VStack
import struct SwiftUI.ViewBuilder


struct KanaPickQuizView: View {
  
  init() {
    viewModel = HiraganaPickQuizViewModel()
  }
  
  var body: some View {
    KanaQuizBody(viewModel: viewModel) { challenge in
      challengeView(challenge: challenge)
    }
  }
  
  // MARK: - Private
  
  @ObservedObject private var viewModel: HiraganaPickQuizViewModel
  
  @ViewBuilder
  private func challengeView(challenge: KanaPickChallenge) -> some View {
    // TODO: Find a better way do macros with declarative statements
#if os(iOS)
    VStack {
      KanaQuizViews.inputView(rep: challenge.inputRep, viewModel: viewModel)
        .frame(height: 200)
        .frame(maxWidth: Canvas.width - 10)
        .background(Color.orange.opacity(0.5))
        .cornerRadius(5)
      pickChallengeOutput(outputType: challenge.correctOutput.category, representations: challenge.outputRep)
        .frame(maxWidth: Canvas.width - 10, maxHeight: .infinity)
        .padding(0)
    }
    .frame(width: Canvas.width)
    .background(Color.green.opacity(0.3))
#else
    HStack {
      QuizViews.inputView(rep: challenge.inputRepresentation, viewModel: viewModel)
        .frame(width: 390, height: 290)
        .background(Color.orange.opacity(0.5))
        .cornerRadius(5)
        .padding(5)
      pickChallengeOutput(outputType: challenge.outputType, representations: challenge.outputRepresentations)
        .frame(width: 300, height: 300)
        .padding(0)
    }
    .background(Color.green.opacity(0.3))
#endif
  }
  
  // MARK: - Output
  
  private func pickChallengeOutput(outputType: KanaRepresentation.Category, representations: [KanaRepresentation]) -> some View {
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
  private func outputContent(forRepresentation representation: KanaRepresentation) -> some View {
    switch representation.category {
//      case .image(let rep):
//        QuizViews.viewForImage(withRepresentation: rep, signal: .output)
      case .voice:
        QuizViews.waveformImage
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .padding(10)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Color.blue.opacity(0.5))
          .cornerRadius(5)
//      case .textWithTranslation(let rep):
//        Text(rep.text)
//          .fixedSize(horizontal: false, vertical: true)
//          .multilineTextAlignment(.center)
//          .frame(maxWidth: .infinity, maxHeight: .infinity)
//          .contentShape(Rectangle())
//          .font(.system(size: 25))
//          .frame(maxWidth: .infinity, maxHeight: .infinity)
//          .background(Color.blue.opacity(0.5))
//          .cornerRadius(5)
//      case .textWithFurigana(let rep):
//        QuizViews.textWithFurigana(representation: rep)
//          .background(Color.blue.opacity(0.5))
//          .frame(maxWidth: .infinity, maxHeight: .infinity)
//          .cornerRadius(5)
      case .text:
        Text(representation.string)
          .font(.system(size: 20))
          .background(Color.blue.opacity(0.5))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .cornerRadius(5)
    }
  }
}
