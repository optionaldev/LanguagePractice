//
// The LanguagePractice (macOS) project.
// Created by optionaldev on 16/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View

import struct SwiftUI.Button
import struct SwiftUI.ForEach
import struct SwiftUI.List
import struct SwiftUI.StateObject
import struct SwiftUI.Text
import struct SwiftUI.ViewBuilder
import struct SwiftUI.ZStack

struct MacHomeView: View {
    
    var body: some View {
        ZStack {
            homeView()
            
            // Not a perfect solution, but for now, if let in combination with @StateObject
            // is the only that that not only allows for `dismiss` actions in other views,
            // but also remembers where the view was if the user switches tabs
            if let quiz = viewModel.currentQuiz {
                switch quiz {
                case .hiragana:
                    GenericPickQuizView(viewModel: KanaPickQuizViewModel(entries: EntryProvider.generate(.hiragana)))
                case .katakana:
                    GenericPickQuizView(viewModel: KanaPickQuizViewModel(entries: EntryProvider.generate(.katakana)))
                case .words:
                    PickQuizView()
                }
            }
        }
        .environmentObject(viewModel)
    }
    
    // MARK: - Private
    
    @StateObject private var viewModel: MacHomeViewModel = MacHomeViewModel()
    
    private func homeView() -> some View {
        List {
            ForEach(HomeQuiz.allCases) { quiz in
                Button(action: {
                    viewModel.currentQuiz = quiz
                }, label: {
                    Text(quiz.title)
                })
            }
        }
    }
}
