//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 08/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import SwiftUI

extension Tab {
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .home:
            Text("Home view")
        case .dictionary:
            Text("Dictionary view")
        case .settings:
            Text("Settings view")
        }
    }
}

struct PhoneTabView: View {
 
    var body: some View {
        TabView {
            ForEach(Tab.allCases) { item in
                item.view
                    .tabItem {
                        Image(systemName: item.icon(selected: item == tab))
                        Text(item.name)
                    }
            }
        }
    }
    
    // MARK: - Private
    
    @State private var tab: Tab = .home
}
