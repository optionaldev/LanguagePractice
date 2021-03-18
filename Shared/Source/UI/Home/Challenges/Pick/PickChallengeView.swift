//
// The LanguagePractice project.
// Created by optionaldev on 08/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import func SwiftUI.withAnimation

import protocol SwiftUI.View

import struct SwiftUI.Button
import struct SwiftUI.Color
import struct SwiftUI.ForEach
import struct SwiftUI.HStack
import struct SwiftUI.LazyHStack
import struct SwiftUI.Text
import struct SwiftUI.ObservedObject
import struct SwiftUI.PlainButtonStyle
import struct SwiftUI.Rectangle
import struct SwiftUI.ScrollView
import struct SwiftUI.ScrollViewReader
import struct SwiftUI.Spacer
import struct SwiftUI.VStack
import struct SwiftUI.ViewBuilder
import struct SwiftUI.ZStack

struct PickChallengeView: View {
    
    var body: some View {
        #if os(iOS)
        container()
            // TODO: Replace with custom bar
            .navigationBarTitle("", displayMode: .inline)
        #else
        container()
        #endif
    }
    
    // MARK: - Private
    
    @ObservedObject private var viewModel = PickChallengeViewModel()
    
    private func container() -> some View {
        ZStack {
            ScrollView(.horizontal) {
                ScrollViewReader { value in
                    LazyHStack(spacing: 0) {
                        ForEach(viewModel.history) { word in
                            challengeView(challenge: word)
                        }
                    }
                    .onChange(of: viewModel.history) { val in
                        withAnimation {
                            value.scrollTo(val.last!.id)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func challengeView(challenge: PickChallenge) -> some View {
        // TODO: Find a better way do macros with declarative statements
        #if os(iOS)
        VStack {
            inputView(rep: challenge.inputRepresentation)
                .frame(height: 200)
                .frame(maxWidth: Screen.width - 10)
                .background(Color.orange.opacity(0.5))
                .cornerRadius(5)
            pickChallengeOutput(outputType: challenge.outputType, representations: challenge.outputRepresentations)
                .frame(maxWidth: Screen.width - 10, maxHeight: .infinity)
                .padding(0)
        }
        .frame(width: Screen.width)
        .background(Color.green.opacity(0.3))
        #else
        VStack {
            inputView(rep: challenge.inputRepresentation)
                .frame(width: 300, height: 200)
                .background(Color.orange.opacity(0.5))
                .cornerRadius(5)
            pickChallengeOutput(outputType: challenge.outputType, representations: challenge.outputRepresentations)
                .frame(width: 300, height: 300)
                .padding(0)
        }
        .background(Color.green.opacity(0.3))
        #endif
    }
    
    @ViewBuilder
    private func inputView(rep: Rep) -> some View {
        switch rep {
        case .voice:
            Text("TODO")
        case .textWithTranslation(let rep):
            VStack {
                Text(" ")
                Text(rep.text)
                    .font(.system(size: 30))
                Text(rep.translation)
                    .opacity(AppConstants.defaultOpacity)
            }
        case .simpleText(let rep):
            Text(rep.text)
                .font(.system(size: 30))
        case .textWithFurigana(let rep):
            textWithFurigana(representation: rep)
                .background(Color.blue.opacity(0.5))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(5)
        case .image(let rep):
            Text("TODO")
        }
    }
    
    private func textWithFurigana(representation: TextWithFuriganaRep) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<representation.text.count, id: \.self) { index in
                VStack(alignment: .center, spacing: 0) {
                    if representation.furigana.isEmpty == false {
                        Text(representation.furigana[index])
                            .foregroundColor(Color.black)
                            .font(.system(size: 15))
                            .opacity(AppConstants.defaultOpacity)
                            .background(Color.blue.opacity(0.3))
                    }
                    Text("\(representation.text[index])")
                        .font(.system(size: 30))
                        .padding(.bottom, 5)
                        .background(Color.green.opacity(0.3))
                }
                .background(Color.purple.opacity(0.3))
            }
        }
    }
    
    // MARK: - Output
    
    private func pickChallengeOutput(outputType: ChallengeType, representations: [Rep]) -> some View {
        MatrixView(columns: 2, rows: 3) { index in
            Button {
                // TODO: Implement action
            } label: {
                outputContent(forRepresentation: representations[index])
                    .contentShape(Rectangle())
                    .padding(0)
                    .background(Color.blue.opacity(0.5))
                    .cornerRadius(5)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func outputContent(forRepresentation representation: Rep) -> some View {
        switch representation {
        case .image(let rep):
            fatalError("TODO")
        case .voice:
            fatalError("TODO")
        case .textWithTranslation(let rep):
            Text(rep.text)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .font(.system(size: 25))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue.opacity(0.5))
                .cornerRadius(5)
        case .textWithFurigana(let rep):
            textWithFurigana(representation: rep)
                .background(Color.blue.opacity(0.5))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(5)
        case .simpleText(let rep):
            Text(rep.text)
                .font(.system(size: 20))
                .background(Color.blue.opacity(0.5))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(5)
        }
    }
}
