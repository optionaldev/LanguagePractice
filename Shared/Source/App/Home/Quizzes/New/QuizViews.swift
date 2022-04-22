//
// The LanguagePractice project.
// Created by optionaldev on 12/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

import Dispatch

import protocol SwiftUI.View

import struct SwiftUI.AppStorage
import struct SwiftUI.Color
import struct SwiftUI.CGFloat
import struct SwiftUI.Environment
import struct SwiftUI.Font
import struct SwiftUI.ForEach
import struct SwiftUI.HStack
import struct SwiftUI.Image
import struct SwiftUI.Spacer
import struct SwiftUI.Text
import struct SwiftUI.ViewBuilder
import struct SwiftUI.VStack
import SwiftUI


struct QuizViews {
  
  static let waveformImage = Image(systemName: "waveform.circle")
  
  static func customFont(ofSize size: CGFloat) -> Font {
    if let fontName = Defaults.string(forKey: .kanjiFontName) {
      return .custom(fontName, size: size)
    }
    return .system(size: size)
  }
  
  @AppStorage(DefaultsStringKey.kanjiFontName.rawValue) static var kanjiFontName: String?
  @AppStorage(DefaultsBoolKey.voiceEnabled.rawValue) static var voiceEnabled: Bool = Defaults.voiceEnabled
  
  @ViewBuilder
  static func inputView(rep: InputRepresentation, viewModel: InputTappable) -> some View {
    switch rep {
      case .voice(let rep):
        waveformImage
          .resizable()
          .frame(width: 50, height: 50)
          .onTapGesture {
            viewModel.inputTapped(initial: false)
          }
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
              viewModel.inputTapped(initial: true)
            }
          }
      case .textWithTranslation(let rep):
        VStack {
          Text(" ")
          Text(rep.text)
            .font(customFont(ofSize: 30))
          Text(rep.translation)
            .opacity(AppConstants.defaultOpacity)
            .font(customFont(ofSize: 15))
        }
      case .text(let rep):
        Text(rep)
          .multilineTextAlignment(.center)
          .font(customFont(ofSize: 30))
      case .textWithRegularFurigana(let rep):
        textWithFurigana(representation: rep, regular: true)
          .background(Color.blue.opacity(0.5))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .cornerRadius(5)
      case .textWithIrregularFurigana(let rep):
        textWithFurigana(representation: rep, regular: false)
          .background(Color.blue.opacity(0.5))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .cornerRadius(5)
        //      case .textWithIrregularFurigana(let rep):
      case .image(let rep):
        viewForImage(id: rep, signal: .output)
    }
  }
  
  @ViewBuilder
  static func textWithFurigana(representation: FuriganaRep, regular: Bool) -> some View {
    if regular {
      HStack(spacing: 0) {
        ForEach(0..<representation.text.count, id: \.self) { index in
          VStack(alignment: .center, spacing: 0) {
            if representation.groups.isEmpty == false {
              Text(representation.groups[index])
                .foregroundColor(Color.black)
                .font(customFont(ofSize: 15))
                .opacity(AppConstants.defaultOpacity)
                .background(Color.blue.opacity(0.3))
            }
            Text("\(representation.text[index])")
              .font(customFont(ofSize: 30))
              .padding(.bottom, 5)
              .background(Color.green.opacity(0.3))
          }
          .background(Color.purple.opacity(0.3))
        }
      }
    } else {
      VStack(alignment: .leading) {
        Text(representation.groups.joined())
          .foregroundColor(Color.black)
          .font(customFont(ofSize: 15))
          .opacity(AppConstants.defaultOpacity)
          .background(Color.blue.opacity(0.3))
        Text(representation.text.joined())
          .font(customFont(ofSize: 30))
          .padding(.bottom, 5)
          .background(Color.green.opacity(0.3))
      }
      .background(Color.purple.opacity(0.3))
    }
  }
  
  @ViewBuilder
  static func viewForImage(id: String, signal: ChallengeSlot) -> some View {
    if let customImage = imageCache.image(forID: id) {
      Image(customImage: customImage)
        .resizable()
        .cornerRadius(5)
    } else {
      // Should never end up on the else branch, but just in case
      Text(id)
    }
  }
  
  @Environment(\.imageCache) private static var imageCache
  
}
