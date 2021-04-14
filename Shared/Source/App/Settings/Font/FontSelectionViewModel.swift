//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 14/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.ObservableObject

import struct SwiftUI.Published

private struct Constants {
    
    static let kanjiCompatibleFontsFound: [String] = [
        "Hiragino Maru Gothic ProN",
        "Hiragino Mincho ProN",
        "Hiragino Sans",
        "PingFang HK",
        "PingFang SC",
        "PingFang TC"
    ]
}

final class FontSelectionViewModel: ObservableObject {
    
    @Published var fontName: String?
    
    init() {
        if let initialKanjiFontName = Defaults.string(forKey: .kanjiFontName) {
            fontName = initialKanjiFontName
        }
    }
    
    func setFont(_ fontName: String) {
        Defaults.set(fontName, forKey: .kanjiFontName)
        self.fontName = fontName
    }
}
