//
// The LanguagePractice project.
// Created by optionaldev on 16/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View

import struct SwiftUI.Button
import struct SwiftUI.Font
import struct SwiftUI.ForEach
import struct SwiftUI.List
import struct SwiftUI.ObservedObject
import struct SwiftUI.Spacer
import struct SwiftUI.Text
import struct SwiftUI.VStack
import struct SwiftUI.ZStack


struct FontSelectionView: View {
    
    @ObservedObject var viewModel: FontSelectionViewModel
    
    var font: Font {
        if let fontName = viewModel.fontName {
            return .custom(fontName, size: 30)
        }
        return .system(size: 30)
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text("日一大年中会人本月長")
                        .font(font)
                    Text("国出上十生子分東三")
                        .font(font)
                    Text("行同今高金時手見市力")
                        .font(font)
                }
                .frame(height: 130)
                Spacer()
            }
            List {
                Button("Default") {
                    viewModel.setFont(nil)
                }
                ForEach(viewModel.fontViewModels) { fontViewModel in
                    Button("\(fontViewModel.name)") {
                        viewModel.setFont(fontViewModel)
                    }
                }
            }
            .padding(.top, 130)
        }
        .padding(.top, 15)
    }
}
