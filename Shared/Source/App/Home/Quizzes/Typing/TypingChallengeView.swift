//
// The LanguagePractice project.
// Created by optionaldev on 29/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View

import struct SwiftUI.Color
import struct SwiftUI.ObservedObject
import struct SwiftUI.Spacer
import struct SwiftUI.ViewBuilder
import struct SwiftUI.VStack


struct TypingQuizView: View {
  
  var body: some View {
    QuizBody(viewModel: viewModel) { challenge in
      challengeView(challenge: challenge)
    }
  }
  
  // MARK: - Private
  
  @ObservedObject private var viewModel: TypingQuizViewModel
  
  @ViewBuilder
  private func challengeView(challenge: TypingChallenge) -> some View {
    VStack {
      QuizViews.inputView(rep: challenge.inputRepresentation, viewModel: viewModel)
        .frame(height: 200)
        .frame(maxWidth: Canvas.width - 10)
        .background(Color.orange.opacity(0.5))
        .cornerRadius(5)
      Spacer()
    }
    .frame(width: Canvas.width)
    .background(Color.green.opacity(0.3))
  }
}
