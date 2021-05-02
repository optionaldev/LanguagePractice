//
// The LanguagePractice project.
// Created by optionaldev on 19/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import func SwiftUI.withAnimation

import protocol SwiftUI.View
import protocol SwiftUI.ViewModifier

import struct SwiftUI.Button
import struct SwiftUI.Color
import struct SwiftUI.ForEach
import struct SwiftUI.HStack
import struct SwiftUI.ScrollView
import struct SwiftUI.ScrollViewReader
import struct SwiftUI.Spacer
import struct SwiftUI.Text
import struct SwiftUI.ViewBuilder
import struct SwiftUI.VStack
import struct SwiftUI.ZStack

#if os(iOS)
import struct SwiftUI.Environment
import struct SwiftUI.LazyHStack
private typealias LazyStack = LazyHStack
#else
import struct SwiftUI.EnvironmentObject
import struct SwiftUI.LazyVStack
private typealias LazyStack = LazyVStack
#endif


private struct Constants {
    
    static let resultsID = "results_screen"
}

struct QuizBody<ViewModel: Quizable, Content: View>: View {
    
    var viewModel: ViewModel
    let content: (ViewModel.Challenge) -> Content
    
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
        ZStack {
            // On iOS it makes more sense to have the content scroll horizontally because the pressable
            // output buttons should be towards the bottom of the screen, for easy access and finger comfort
            // On MacOS, horizontal ScrollView doesn't have a built in drag gesture
            // What it does have is scroll wheel integration, but that only work with vertical scroll views
            // and even if it worked with horizontal ones, it's just more natural to scroll vertically on mac
            ScrollView(iOS ? .horizontal : .vertical, showsIndicators: iOS ? true : false) {
                ScrollViewReader { value in
                    LazyStack(spacing: 0) {
                        ForEach(viewModel.visibleChallenges) { challenge in
                            content(challenge)
                                .disabled(challenge != viewModel.visibleChallenges.last)
                        }
                        if viewModel.wordsLearned.isEmpty == false {
                            resultsScreen()
                        }
                    }
                    .onChange(of: viewModel.visibleChallenges) { visibleChallenges in
                        withAnimation {
                            value.scrollTo(visibleChallenges.last!.id)
                        }
                    }
                    .onChange(of: viewModel.wordsLearned) { _ in
                        withAnimation {
                            value.scrollTo(Constants.resultsID)
                        }
                    }
                }
            }
            
            // We keep the topBar as the last view in the ZStack because
            // if we place it first, it's no longer tappable
            topBar()
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
    
    // Used for dismissing this view
    #if os(iOS)
    @Environment(\.presentationMode) private var presentationMode
    #else
    @EnvironmentObject private var homeViewModel: MacHomeViewModel
    #endif
    
    private func topBar() -> some View {
        // Navigation bars are in the same ZStack as the ChallengeWordView due to small screens
        // where we want the buttons to overlap the images, to preserve space
        // Also, placing these above the ScrollView would make the buttons unpressable
        VStack {
            HStack {
                // Replacement for back button, in order to avoid accidental swipe out of challenge
                Button(action: {
                    #if os(iOS)
                    presentationMode.wrappedValue.dismiss()
                    #else
                    homeViewModel.currentQuiz = nil
                    #endif
                }, label: {
                    Text("Exit")
                })
                .padding(10)
                .cornerRadius(3)
                Spacer()
            }
            Spacer()
        }
    }
}
