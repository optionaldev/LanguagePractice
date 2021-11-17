//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 17/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 


import protocol SwiftUI.View

import struct SwiftUI.Image
import struct SwiftUI.List
import struct SwiftUI.ObservedObject
import struct SwiftUI.Picker
import struct SwiftUI.SegmentedPickerStyle
import struct SwiftUI.Text
import struct SwiftUI.VStack


struct LexiconItemView: View {
  
  let item: Item
  
  static let waveformImage = Image(systemName: "waveform.circle")
  
  var body: some View {
    VStack {
      Text(item.written)
      LexiconItemView.waveformImage
        .onTapGesture {
          Speech.shared.speak(string: item.spoken, language: item is ForeignItem ? .foreign : .english)
      }
    }
//    VStack {
//      Picker("", selection: $viewModel.selection) {
//        Text("English").tag(Language.english)
//        Text("Foreign").tag(Language.foreign)
//      }.pickerStyle(SegmentedPickerStyle())
//      CustomTextField(text: $viewModel.searchString)
//        .frame(width: Screen.width - 30, height: 40)
//      List(viewModel.displayedItems, id: \.id) { item in
//        CustomLabel(text: item.text)
//      }
//    }
  }
  
  // MARK: - Private
  
  @ObservedObject private var viewModel = LexiconViewModel()
}
