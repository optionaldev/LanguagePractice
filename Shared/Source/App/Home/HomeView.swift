//
// The LanguagePractice project.
// Created by optionaldev on 02/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View

import struct SwiftUI.ObservedObject
import struct SwiftUI.ViewBuilder

#if os(iOS)
import struct SwiftUI.NavigationView
import struct SwiftUI.NavigationLink
import struct SwiftUI.List
#endif

struct HomeView: View {
  
  init() {
    log("HomeView init")
    #if os(iOS)
    // On iOS, the view only gets drawn once with the native TabView, but in MacOS, we use a custom
    // TabView that behaves differently, so we call requestAnyMissingItems() from a different place
    viewModel.requestAnyMissingItems()
    #endif
  }
  
  var body: some View {
    #if os(iOS)
    NavigationView {
      List {
        NavigationLink("Pick", destination: NavigationLazyView(PickQuizView(entryType: .words)))
          .navigationBarHidden(true)
        NavigationLink("Hiragana", destination: NavigationLazyView(PickQuizView(entryType: .hiragana)))
          .navigationBarHidden(true)
        NavigationLink("Katakana", destination: NavigationLazyView(PickQuizView(entryType: .katakana)))
          .navigationBarHidden(true)
        NavigationLink("Typing", destination: NavigationLazyView(TypingQuizView()))
          .navigationBarHidden(true)
        NavigationLink("New hiragana", destination: NavigationLazyView(KanaPickQuizView()))
          .navigationBarHidden(true)
        
      }
    }
    #else
    MacHomeView()
      .environment(\.imageCache, imageCache)
      .onAppear {
        log("Home on appear triggered")
        viewModel.requestAnyMissingItems()
      }
    #endif
  }
  
  // MARK: - Private
  
  @ObservedObject private var viewModel = HomeViewModel()
  
  private let imageCache = ImageCache()
}
