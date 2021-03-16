//
// The LanguagePractice (macOS) project.
// Created by optionaldev on 14/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import SwiftUI

typealias SideMenuItem = Tab

struct SideMenuView: View {
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                ForEach(SideMenuItem.allCases) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        sideMenuItemView(for: item)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer()
                checkbox
            }
            .frame(width: showLabelCheckbox ? 150 : 50)
            .background(Color.black.opacity(0.1))
            
            // Add separator here?
            
            content
                .frame(maxWidth: .infinity)
        }
        .frame(width: showLabelCheckbox ? 450 : 350)
    }
    
    // MARK: - Private
    
    @ViewBuilder
    private func sideMenuItemView(for item: SideMenuItem) -> some View {
        HStack {
            Image(systemName: item.icon(selected: selectedItem == item))
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.all, 15)
                .foregroundColor(selectedItem == item ? .blue : .gray)
            if showLabelCheckbox {
                Text(item.name)
            }
            Spacer()
        }
        // Pressing between the image and the text doesn't work without a background
        // There's probably a better way to do this, but for now it should suffice
        .background(Color.black.opacity(0.01))
    }
    
    @ViewBuilder
    private var content: some View {
        switch selectedItem {
        case .home:
            HomeView()
        case .dictionary:
            Text("Content = Dictionary")
        case .settings:
            Text("Content = Settings")
        }
    }
    
    @ViewBuilder
    private var checkbox: some View {
        Button {
            showLabelCheckbox.toggle()
            Defaults.macOS.set(showLabelCheckbox, forKey: .sideMenuShowLabels)
        } label: {
            if showLabelCheckbox {
                HStack {
                    checkboxView
                    Text("Show labels")
                }
            } else {
                checkboxView
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.all, 17)
    }
    
    private var checkboxView: some View {
        Image(systemName: showLabelCheckbox ? "checkmark.square" : "square")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(.gray)
            .opacity(0.5)
    }
    
    @State private var selectedItem: SideMenuItem = .home
    @State private var showLabelCheckbox: Bool = Defaults.macOS.bool(forKey: .sideMenuShowLabels)
}
