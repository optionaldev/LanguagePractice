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

struct LexiconView: View {
  
  private let displayedItems: [Item]
  
  init() {
    displayedItems = Lexicon.shared.english.nouns.sorted(by: { (first, second) -> Bool in
      return first.id.lowercased() < second.id.lowercased()
    })
  }
  
  var body: some View {
    List(displayedItems, id: \.id) { item in
      Text(item.id)
    }
  }
  
  // MARK: - Private
  
  @ObservedObject private var viewModel = LexiconViewModel()
}
