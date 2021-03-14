//
// The LanguagePractice project.
// Created by optionaldev on 02/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView {
            #if os(iOS)
            NavigationLink("Pick", destination: NavigationLazyView(PickChallengeView()))
                .navigationBarTitle("")
                .navigationBarHidden(true)
            #else
            NavigationLink("Pick", destination: NavigationLazyView(PickChallengeView()))
            #endif
        }
        .onAppear {
            viewModel.requestAnyMissingItems()
        }
    }
    
    // MARK: - Private
    
    @ObservedObject private var viewModel = HomeViewModel()
    
}
