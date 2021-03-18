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
    
    let columns: Int
    let rows: Int
    let content: (Int) -> Content
    
    private var total: Int {
        return columns * rows
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< columns) { column in
                VStack(spacing: 0) {
                    ForEach(0 ..< rows) { row in
                        content(rows * column + row)
                    }
                }
            }
        }
    }
}
