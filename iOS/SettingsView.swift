//
// The LanguagePractice project.
// Created by optionaldev on 16/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View

import struct SwiftUI.List
import struct SwiftUI.NavigationLink
import struct SwiftUI.NavigationView
import struct SwiftUI.Spacer
import struct SwiftUI.State
import struct SwiftUI.Text
import struct SwiftUI.Toggle
import struct SwiftUI.ViewBuilder
import Foundation

struct SettingsView: View {
  
  @ViewBuilder
  var body: some View {
    
    content()
  }
  
  // MARK: - Private
  
  @State private var voiceEnabled = UserDefaults.standard.bool(forKey: DefaultsBoolKey.voiceEnabled.rawValue)
  
  private func content() -> some View {
    NavigationView {
      List {
        NavigationLink(destination: NavigationLazyView(FontSelectionView())) {
          Text("Select font")
        }
        Toggle("Voice enabled", isOn: $voiceEnabled)
      }
      .navigationBarHidden(true)
      .onChange(of: voiceEnabled, perform: { _ in
        Defaults.set(voiceEnabled, forKey: .voiceEnabled)
      })
    }
  }
}
