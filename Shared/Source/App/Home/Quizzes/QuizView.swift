//
// The LanguagePractice project.
// Created by optionaldev on 25/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import Dispatch

import protocol SwiftUI.View

import struct SwiftUI.Color
import struct SwiftUI.ForEach
import struct SwiftUI.HStack
import struct SwiftUI.Image
import struct SwiftUI.Text
import struct SwiftUI.ViewBuilder
import struct SwiftUI.VStack



struct QuizView {
    
    static let waveformImage = Image(systemName: "waveform.circle")
    
    @ViewBuilder
    static func inputView<ViewModel: Quizable>(rep: Rep, viewModel: ViewModel) -> some View {
        switch rep {
        case .voice:
            waveformImage
                .resizable()
                .frame(width: 50, height: 50)
                .onTapGesture {
                    viewModel.inputTapped()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        viewModel.inputTapped()
                    }
                }
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
            viewForImage(withRepresentation: rep, signal: .output)
        }
    }
    
    static func textWithFurigana(representation: TextWithFuriganaRep) -> some View {
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
    
    @ViewBuilder
    static func viewForImage(withRepresentation rep: ImageRep, signal: ChallengeSlot) -> some View {
        if let customImage = imageCache.image(forID: rep.imageID) {
            Image(customImage: customImage)
                .resizable()
                .cornerRadius(5)
        } else {
            // Should never end up on the else branch, but just in case
            Text(rep.imageID.removingDigits())
        }
    }
    
    // TODO: Replace with environment var / object
    private static let imageCache = ImageCache()
}
