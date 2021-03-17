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
    
    var body: some View {
        view()
            .onAppear {
                viewModel.requestAnyMissingItems()
            }
    }
    
    // MARK: - Private
    
    @ObservedObject private var viewModel = HomeViewModel()
    
    @ViewBuilder
    private func view() -> some View {
        #if os(iOS)
        NavigationView {
            NavigationLink("Pick", destination: NavigationLazyView(PickChallengeView()))
                .navigationBarHidden(true)
        }
        #else
        MacHomeView()
        #endif
    }
}
