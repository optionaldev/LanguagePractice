//
// The LanguagePractice project.
// Created by optionaldev on 02/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import CoreData
import SwiftUI

struct HomeView: View {
    
    var body: some View {
        Text("Shared home")
            .onAppear {
                viewModel.requestAnyMissingItems()
            }
    }
    
    // MARK: - Private
    
    @ObservedObject private var viewModel = HomeViewModel()
    
}
