//
// The LanguagePractice project.
// Created by optionaldev on 16/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View

import struct SwiftUI.List
import struct SwiftUI.NavigationLink
import struct SwiftUI.NavigationView
import struct SwiftUI.Text
import struct SwiftUI.ViewBuilder

struct SettingsView: View {
    
    @ViewBuilder
    var body: some View {
        #if os(iOS)
        content()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Settings")
        #else
        content()
        #endif
    }
    
    
    private func content() -> some View {
        NavigationView {
            List {
                NavigationLink(destination: NavigationLazyView(FontSelectionView(viewModel: FontSelectionViewModel()))) {
                    Text("Select font")
                }
            }
            .padding(.top, 10)
        }
    }
}
