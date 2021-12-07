//
// The LanguagePractice project.
// Created by optionaldev on 29/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View

import struct SwiftUI.Button
import struct SwiftUI.Color
import struct SwiftUI.ForEach
import struct SwiftUI.HStack
import struct SwiftUI.ObservedObject
import struct SwiftUI.Spacer
import struct SwiftUI.Text
import struct SwiftUI.ViewBuilder
import struct SwiftUI.VStack
import struct SwiftUI.ZStack


struct TypingQuizView: View {
  
  var body: some View {
    VStack {
      ZStack {
        QuizBody(viewModel: viewModel) { challenge in
          challengeView(challenge: challenge)
        }
        forfeitButton
      }
      .frame(width: Canvas.width, height: 200)
      .background(Color.blue.opacity(0.3))
      CustomTextField(text: $viewModel.currentText)
        .frame(width: 200, height: 50)
        .background(Color.red.opacity(0.3))
      Spacer()
        .onTapGesture {
          Keyboard.dismiss()
        }
    }
    .frame(width: Canvas.width)
    .background(Color.red.opacity(0.3))
  }
  
  // MARK: - Private
  
  @ObservedObject private var viewModel = TypingQuizViewModel()
  
  @ViewBuilder
  private func challengeView(challenge: TypingChallenge) -> some View {
    ZStack {
      QuizViews.inputView(rep: challenge.inputRepresentation, viewModel: viewModel)
      forfeitAnswers(forChallenge: challenge)
    }
    .frame(width: Canvas.width - 10, height: 200)
    .background(Color.orange.opacity(0.5))
    .padding(5)
    .cornerRadius(10)
  }
  
  private func forfeitAnswers(forChallenge challenge: TypingChallenge) -> some View {
    VStack {
      Spacer()
      HStack {
        ForEach(challenge.output, id: \.self) { output in
          Text(output)
        }
      }
    }
    .opacity(viewModel.challengeState == .forfeited(3) ? 1 : 0)
  }
  
  private var forfeitButton: some View {
    VStack {
      HStack {
        Spacer()
        Button("Forfeit") {
          viewModel.forfeitCurrentChallenge()
        }
        .padding(10)
      }
      Spacer()
    }
  }
}
