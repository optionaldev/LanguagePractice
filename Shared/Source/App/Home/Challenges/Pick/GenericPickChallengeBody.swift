//
// The LanguagePractice project.
// Created by optionaldev on 06/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 


import func SwiftUI.withAnimation

import protocol SwiftUI.Gesture
import protocol SwiftUI.View
import protocol SwiftUI.ViewModifier

import struct SwiftUI.CGSize
import struct SwiftUI.Color
import struct SwiftUI.DragGesture
import struct SwiftUI.ForEach
import struct SwiftUI.ScrollView
import struct SwiftUI.ModifiedContent
import struct SwiftUI.ScrollViewReader
import struct SwiftUI.State
import struct SwiftUI.Text
import struct SwiftUI.ViewBuilder
import struct SwiftUI.VStack

#if os(iOS)
import struct SwiftUI.LazyHStack
private typealias LazyStack = LazyHStack
#else
import struct SwiftUI.LazyVStack
private typealias LazyStack = LazyVStack
#endif


private struct Constants {
    
    static let resultsID = "results_screen"
}

struct GenericPickChallengeBody<ViewModel: ViewModelProtocol, Content: View>: View {
    
    let viewModel: ViewModel
    let content: (PickChallenge) -> Content
    
    var body: some View {
        #if os(iOS)
        bodyContent
            // Makes navigation bar smaller on iOS
            // TODO: Hide navigation bar entirely and replace with custom bar
            .navigationBarTitle("", displayMode: .inline)
        #else
        bodyContent
        #endif
    }
    
    // MARK: - Private
    
    @ViewBuilder
    private var bodyContent: some View {
        // On iOS it makes more sense to have the content scroll horizontally because the pressable
        // output buttons should be towards the bottom of the screen, for easy access and finger comfort
        // On MacOS, horizontal ScrollView doesn't have a built in drag gesture
        // What it does have is scroll wheel integration, but that only work with vertical scroll views
        // and even if it worked with horizontal ones, it's just more natural to scroll vertically on mac
        ScrollView(iOS ? .horizontal : .vertical, showsIndicators: iOS ? true : false) {
            ScrollViewReader { value in
                LazyStack(spacing: 0) {
                    ForEach(viewModel.history) { challenge in
                        content(challenge)
                    }
                    if viewModel.wordsLearned.isEmpty == false {
                        resultsScreen()
                    }
                }
                .onChange(of: viewModel.history) { val in
                    withAnimation {
                        value.scrollTo(val.last!.id)
                    }
                }
                .onChange(of: viewModel.wordsLearned) { _ in
                    withAnimation {
                        value.scrollTo(Constants.resultsID)
                    }
                }
            }
        }
    }
    
    private func resultsScreen() -> some View {
        VStack {
            ForEach(0..<viewModel.wordsLearned.count) { index in
                Text(viewModel.wordsLearned[index])
                    .padding(5)
            }
        }
        .frame(width: Canvas.width, height: iOS ? nil : Canvas.height)
        .id(Constants.resultsID)
        .background(Color.blue)
    }
}
