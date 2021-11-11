//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 07/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View

import struct SwiftUI.ForEach
import struct SwiftUI.LazyVStack
import struct SwiftUI.List
import struct SwiftUI.ObservedObject
import struct SwiftUI.ScrollView
import struct SwiftUI.Text
import struct SwiftUI.VStack

import SwiftUI
import UIKit

struct LexiconView: View {
  
  var body: some View {
    VStack {
      CustomTextField(text: $viewModel.searchString)
        .frame(width: UIScreen.main.bounds.width - 30, height: 40)
      List(viewModel.displayedItems, id: \.id) { item in
        CustomLabel(text: NSAttributedString(string: item.id))
      }
    }
  }
  
  // MARK: - Private
  
  @ObservedObject private var viewModel = LexiconViewModel()
}
