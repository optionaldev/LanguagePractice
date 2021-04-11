//
// The LanguagePractice (macOS) project.
// Created by optionaldev on 16/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View

import struct SwiftUI.Button
import struct SwiftUI.State
import struct SwiftUI.ViewBuilder
import struct SwiftUI.Text
import struct SwiftUI.ZStack

import func SwiftUI.withAnimation

struct MacHomeView: View {
    
    @ViewBuilder
    var body: some View {
        if showPick {
            GenericPickQuizView(viewModel: KanaPickQuizViewModel(entries: HiraganaEntryProvider.generate()))
//            PickChallengeView()
        } else {
            homeView()
        }
    }
    
    // MARK: - Private
    
    @State private var showPick = false
    
    private func homeView() -> some View {
        Button(action: {
            showPick = true
        }, label: {
            Text("Pick")
        })
    }
}
