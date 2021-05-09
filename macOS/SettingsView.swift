//
// The LanguagePractice (macOS) project.
// Created by optionaldev on 09/05/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import protocol SwiftUI.View

import struct SwiftUI.Button
import struct SwiftUI.State
import struct SwiftUI.Toggle
import struct SwiftUI.VStack
import struct SwiftUI.ZStack

struct SettingsView: View {
  
  var body: some View {
    ZStack {
      VStack {
        Button("Font selection") {
          fontSelectionScreenPresented = true
        }
        Toggle("Voice enabled", isOn: $voiceEnabled)
          .onChange(of: voiceEnabled) { newValue in
            Defaults.set(newValue, forKey: .voiceEnabled)
          }
      }
      if fontSelectionScreenPresented {
        FontSelectionView(presented: $fontSelectionScreenPresented)
      }
    }
  }
  
  // MARK: - Private
  
  @State private var voiceEnabled = Defaults.voiceEnabled
  @State private var fontSelectionScreenPresented = false
}
