//
// The LanguagePractice project.
// Created by optionaldev on 20/05/2022.
// Copyright © 2022 optionaldev. All rights reserved.
//

import protocol SwiftUI.View

import struct SwiftUI.Text
import struct SwiftUI.VStack

struct LexiconDetailsView: View {
  
  private let item: Item
  private let language: Language
  
  init(item: Item, language: Language) {
    self.item = item
    self.language = language
  }
  
  var body: some View {
    VStack {
      Text(item.id)
    }
  }
}
