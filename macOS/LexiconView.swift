//
// The LanguagePractice (macOS) project.
// Created by optionaldev on 07/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View

import struct SwiftUI.HStack
import struct SwiftUI.List
import struct SwiftUI.NavigationLink
import struct SwiftUI.NavigationView
import struct SwiftUI.ObservedObject
import struct SwiftUI.Picker
import struct SwiftUI.SegmentedPickerStyle
import struct SwiftUI.Spacer
import struct SwiftUI.Text
import struct SwiftUI.TextField
import struct SwiftUI.VStack

struct LexiconView: View {
 
  var body: some View {
    NavigationView {
      HStack {
        VStack {
          Picker("", selection: $viewModel.selection) {
            // The picker works by going through the tags
            Text("English").tag(Language.english)
            Text("Foreign").tag(Language.foreign)
          }.pickerStyle(SegmentedPickerStyle())
          TextField("", text: $viewModel.searchString)
            .frame(width: 150, height: 40)
            .multilineTextAlignment(.center)
          List(viewModel.displayedItems, id: \.id) { item in
            NavigationLink(item.id, destination: NavigationLazyView(LexiconDetailsView(item: item, language: viewModel.selection)))
          }
        }
        .frame(width: 150)
        Spacer()
      }
    }
  }
  
  @ObservedObject private var viewModel = LexiconViewModel()
}
