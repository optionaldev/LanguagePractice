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
import struct SwiftUI.LazyHStack
import struct SwiftUI.ForEach
import struct SwiftUI.ScrollView
import struct SwiftUI.ModifiedContent
import struct SwiftUI.ScrollViewReader
import struct SwiftUI.State

import func SwiftUI.withAnimation


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
    
    var bodyContent: some View {
        // When the content appears, it is initially not scrollable
        // After additional content is added, it becomes scrollable
        // On MacOS, once the content becomes scrollable, the scroll bar appears and
        // it enlarges the frame and we don't want that
        // As a workaround, add a drag gesture and solve the scroll bar issue some other way (if at all)
        ScrollView(.horizontal, showsIndicators: iOS ? true : false) {
            ScrollViewReader { value in
                LazyHStack(spacing: 0) {
                    ForEach(viewModel.history) { challenge in
                        content(challenge)
                    }
                }
                .platformSpecificModifier()
                .onChange(of: viewModel.history) { val in
                    withAnimation {
                        value.scrollTo(val.last!.id)
                    }
                }
            }
        }
    }
}

fileprivate struct Modifier: ViewModifier {
    
    func body(content: Content) -> some View {
        #if os(iOS)
        return content
        #else
        return content
            .offset(x: currentOffset.width, y: currentOffset.height)
            .gesture(dragGesture)
        #endif
    }
    
    // MARK: - Private
    
    #if os(macOS)
    @State private var currentOffset:  CGSize = .zero
    @State private var previousOffset: CGSize = .zero
    
    // TODO: Handle minimum scroll and maximum scroll
    // Right now content can be scrolled beyond the edges
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                currentOffset = CGSize(width: value.translation.width + previousOffset.width,
                                       height: previousOffset.height)
            }
            .onEnded { value in
                currentOffset = CGSize(width: value.translation.width + previousOffset.width,
                                       height: previousOffset.height)
                previousOffset = currentOffset
            }
    }
    #endif
}

fileprivate extension View {
    
    func platformSpecificModifier() -> some View {
        ModifiedContent(content: self, modifier: Modifier())
    }
}
