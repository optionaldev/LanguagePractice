//
// The LanguagePractice project.
// Created by optionaldev on 02/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View

import struct SwiftUI.ObservedObject
import struct SwiftUI.ViewBuilder

#if os(iOS)
import struct SwiftUI.NavigationView
import struct SwiftUI.NavigationLink
#endif

struct HomeView: View {
    
    init() {
        log("redraw HomeView")
        #if os(iOS)
        // On iOS, the view only gets drawn once with the native TabView, but in MacOS, we use a custom
        // TabView that behaves differently, so we call requestAnyMissingItems() from a different place
        viewModel.requestAnyMissingItems()
        #endif
    }
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            NavigationLink("Pick", destination: NavigationLazyView(PickChallengeView()))
                .navigationBarHidden(true)
        }
        #else
        MacHomeView()
            .onAppear {
                log("Home on appear triggered")
                viewModel.requestAnyMissingItems()
            }
        #endif
    }
    
    // MARK: - Private
    
    @ObservedObject private var viewModel = HomeViewModel()
}
