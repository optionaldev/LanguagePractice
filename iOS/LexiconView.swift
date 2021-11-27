//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 07/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View

import struct SwiftUI.List
import struct SwiftUI.ObservedObject
import struct SwiftUI.Picker
import struct SwiftUI.SegmentedPickerStyle
import struct SwiftUI.State
import struct SwiftUI.Text
import struct SwiftUI.VStack

import SwiftUI

struct LexiconView: View {
  
  var body: some View {
    // TODO: Find alternative to TabView because this guy initializes the tables waaaay too many times (more SwiftUI nonsense)
      TabView {
        hiraganaTable
        katakanaTable
        wordsTable
      }
      .tabViewStyle(PageTabViewStyle())
  }
  
  // MARK: - Private
  
  @State private var itemViewPresented = false
  
  @ObservedObject private var viewModel = LexiconViewModel()
  
  private var hiraganaTable: some View {
    MatrixView(rows: 11, columns: 5) { row, column in
      Text(fetchHiragana(row: row, column: column)?.written ?? "")
        .frame(width: 45, height: 45)
        .onTapGesture {
          if let hiragana = fetchHiragana(row: row, column: column) {
            Speech.shared.speak(string: hiragana.spoken, language: .foreign)
          }
        }
        .onAppear {
          log("requested for \(row) \(column)")
        }
    }
    .frame(width: Screen.width, height: Screen.height)
  }
  
  private var katakanaTable: some View {
    MatrixView(rows: 11, columns: 5) { row, column in
      Text(fetchKatakana(row: row, column: column)?.written ?? "")
        .frame(width: 45, height: 45)
        .onTapGesture {
          if let katakana = fetchKatakana(row: row, column: column) {
            Speech.shared.speak(string: katakana.spoken, language: .foreign)
          }
        }
        .onAppear {
          log("requested for \(row) \(column)")
        }
    }
    .frame(width: Screen.width, height: Screen.height)
  }
  
  private var wordsTable: some View {
    VStack {
      Picker("", selection: $viewModel.selection) {
        Text("English").tag(Language.english)
        Text("Foreign").tag(Language.foreign)
      }.pickerStyle(SegmentedPickerStyle())
      CustomTextField(text: $viewModel.searchString)
        .frame(width: Screen.width - 30, height: 40)
      List(viewModel.displayedItems, id: \.id) { item in
        CustomLabel(text: item.text)
          .onTapGesture {
            Speech.shared.speak(string: item.id.removingUniqueness(), language: viewModel.selection)
          }
      }
    }
    .frame(width: Screen.width, height: Screen.height)
  }
  
  private func fetchHiragana(row: Int, column: Int) -> ForeignItem? {
    guard let item = Lexicon.shared.foreign.hiragana.filter({ $0.position.first == row && $0.position.last == column }).first else {
      return nil
    }
    return item
  }
  
  private func fetchKatakana(row: Int, column: Int) -> ForeignItem? {
    guard let item = Lexicon.shared.foreign.katakana.filter({ $0.position.first == row && $0.position.last == column }).first else {
      return nil
    }
    return item
  }
}
