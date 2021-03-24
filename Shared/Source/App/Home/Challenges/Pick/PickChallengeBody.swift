//
// The LanguagePractice project.
// Created by optionaldev on 19/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import protocol SwiftUI.Gesture
import protocol SwiftUI.View
import protocol SwiftUI.ViewModifier

import struct SwiftUI.CGSize
import struct SwiftUI.DragGesture
import struct SwiftUI.ForEach
import struct SwiftUI.ScrollView
import struct SwiftUI.ModifiedContent
import struct SwiftUI.ScrollViewReader
import struct SwiftUI.State
import struct SwiftUI.ViewBuilder

import func SwiftUI.withAnimation

#if os(iOS)
import struct SwiftUI.LazyHStack
#else
import struct SwiftUI.LazyVStack
#endif


struct PickChallengeBody<Content: View>: View {
    
    var viewModel: PickChallengeViewModel
    var content: (PickChallenge) -> Content
    
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
    
    private var bodyContent: some View {
        // On iOS it makes more sense to have the content scroll horizontally because the pressable
        // output buttons should be towards the bottom of the screen, for easy access and finger comfort
        // On MacOS, horizontal ScrollView doesn't work out of the box, only vertical works with scroll wheel
        ScrollView(iOS ? .horizontal : .vertical, showsIndicators: iOS ? true : false) {
            ScrollViewReader { value in
                container {
                    ForEach(viewModel.history) { challenge in
                        content(challenge)
                    }
                }
                .onChange(of: viewModel.history) { val in
                    withAnimation {
                        value.scrollTo(val.last!.id)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func container<Container: View>(content: () -> Container) -> some View {
        #if os(iOS)
        LazyHStack(spacing: 0) {
            content()
        }
        #else
        LazyVStack(spacing: 0) {
            content()
        }
        #endif
    }
}
