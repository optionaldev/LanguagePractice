//
// The LanguagePractice project.
// Created by optionaldev on 18/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import protocol SwiftUI.View

import struct SwiftUI.HStack
import struct SwiftUI.ForEach
import struct SwiftUI.VStack


struct MatrixView<Content: View>: View {
  
  let rows: Int
  let columns: Int
  let content: (Int, Int) -> Content
  
  var body: some View {
    VStack(spacing: 0) {
      ForEach(0 ..< rows) { row in
        HStack(spacing: 0) {
          ForEach(0 ..< columns) { column in
            content(row, column)
          }
        }
      }
    }
  }
}
