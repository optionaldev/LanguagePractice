//
// The LanguagePractice (macOS) project.
// Created by optionaldev on 16/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View

import struct SwiftUI.Button
import struct SwiftUI.ForEach
import struct SwiftUI.List
import struct SwiftUI.State
import struct SwiftUI.Text
import struct SwiftUI.ViewBuilder

struct MacHomeView: View {
    
    @ViewBuilder
    var body: some View {
        if let quiz = currentQuiz {
            switch quiz {
            case .hiragana:
                GenericPickQuizView(viewModel: KanaPickQuizViewModel(entries: EntryProvider.generateHiragana()))
            case .katakana:
                GenericPickQuizView(viewModel: KanaPickQuizViewModel(entries: EntryProvider.generateKatakana()))
            case .words:
                PickQuizView()
            }
        } else {
            homeView()
        }
    }
    
    // MARK: - Private
    
    @State private var currentQuiz: HomeQuiz?
    
    private func homeView() -> some View {
        List {
            ForEach(HomeQuiz.allCases) { quiz in
                Button(action: {
                    currentQuiz = quiz
                }, label: {
                    Text(quiz.title)
                })
            }
        }
    }
}
