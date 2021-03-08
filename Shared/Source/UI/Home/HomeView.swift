//
// The LanguagePractice project.
// Created by optionaldev on 02/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import CoreData
import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView {
            NavigationLink("Pick", destination: NavigationLazyView(PickChallengeView()))
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
    }
    
    // MARK: - Private
    
    @ObservedObject private var viewModel = HomeViewModel()
    
}
