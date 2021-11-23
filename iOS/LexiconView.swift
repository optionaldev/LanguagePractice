//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 07/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View

import struct SwiftUI.List
import struct SwiftUI.ObservedObject
import struct SwiftUI.Picker
import struct SwiftUI.SegmentedPickerStyle
import struct SwiftUI.State
import struct SwiftUI.Text
import struct SwiftUI.VStack

import SwiftUI

struct LexiconView: View {
  
  var body: some View {
    
    TabView {
//      VStack {
//        Picker("", selection: $viewModel.selection) {
//          Text("English").tag(Language.english)
//          Text("Foreign").tag(Language.foreign)
//        }.pickerStyle(SegmentedPickerStyle())
//        CustomTextField(text: $viewModel.searchString)
//          .frame(width: Screen.width - 30, height: 40)
//        List(viewModel.displayedItems, id: \.id) { item in
//          CustomLabel(text: item.text)
//            .onTapGesture {
//              Speech.shared.speak(string: item.id.removingUniqueness(), language: viewModel.selection)
//            }
//        }
//      }
//      .frame(width: Screen.width)
      MatrixView(rows: 11, columns: 5) { row, column in
        Text(Lexicon.shared.foreign.hiragana.filter { $0.position.first == row && $0.position.last == column }.first?.id ?? "")
          .frame(width: 50, height: 50)
      }
      .frame(width: Screen.width)
      .background(Color.blue)
    }.tabViewStyle(PageTabViewStyle())
  }
  
  // MARK: - Private
  
  @State private var itemViewPresented = false
  
  @ObservedObject private var viewModel = LexiconViewModel()
}
