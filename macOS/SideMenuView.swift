//
// The LanguagePractice (macOS) project.
// Created by optionaldev on 14/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View

import struct SwiftUI.Button
import struct SwiftUI.CGFloat
import struct SwiftUI.Color
import struct SwiftUI.ForEach
import struct SwiftUI.HStack
import struct SwiftUI.Image
import struct SwiftUI.PlainButtonStyle
import struct SwiftUI.Spacer
import struct SwiftUI.State
import struct SwiftUI.Text
import struct SwiftUI.ViewBuilder
import struct SwiftUI.VStack
import struct SwiftUI.ZStack


private struct Constants {
    
    static let padding: CGFloat = 15
    static let sideItemSize: CGFloat = 20
}


typealias SideMenuItem = Tab

struct SideMenuView: View {
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(SideMenuItem.allCases) { item in
                    Button(action: {
                        selectedItem = item
                    }, label: {
                        sideMenuItemView(for: item)
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer()
                checkbox
            }
            .padding([.top, .leading, .bottom], 15)
            .opacity(0.7)
            .background(Color.gray.opacity(0.1))

            // TODO: check if it's possible to change to expand the frame to the left instead of to
            // the right such that we can keep the position of the challenge portion where it is
            .frame(width: showLabelCheckbox ? 150 : 50)
            ZStack {
                // On MacOS, all views exist at the same time and displaying is based on opacity
                // because TabView doesn't seem very customizable right now. Other approaches
                // have been attempted, but this is the only one I've found so far that makes
                // the views be persistent
                HomeView()
                    .opacity(selectedItem == .home ? 1 : 0)
                Text("Mac Dictionary")
                    .opacity(selectedItem == .dictionary ? 1 : 0)
                Text("Mac Settings")
                    .opacity(selectedItem == .settings ? 1 : 0)
            }
            .frame(width: 700)
            // For some reason, without this padding, the ScrollView acts a bit strange
            // ScrollViewReader method scrollTo() doesn't go all the way to the bottom
            .padding(.all, 1)
        }
        .frame(height: 302)
    }
    
    // MARK: - Private
    
    @State private var selectedItem: SideMenuItem = .home
    @State private var showLabelCheckbox: Bool = Defaults.macOS.bool(forKey: .sideMenuShowLabels)
    
    @ViewBuilder
    private func sideMenuItemView(for item: SideMenuItem) -> some View {
        HStack {
            Image(systemName: item.icon(selected: selectedItem == item))
                .resizable()
                .frame(width: Constants.sideItemSize, height: Constants.sideItemSize)
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
    private var checkbox: some View {
        Button {
            showLabelCheckbox.toggle()
            Defaults.macOS.set(showLabelCheckbox, forKey: .sideMenuShowLabels)
        } label: {
            if showLabelCheckbox {
                HStack {
                    checkboxView
                    Text("Show labels")
                    Spacer()
                }
            } else {
                HStack {
                    checkboxView
                    Spacer()
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var checkboxView: some View {
        Image(systemName: showLabelCheckbox ? "checkmark.square" : "square")
            .resizable()
            .frame(width: Constants.sideItemSize, height: Constants.sideItemSize)
            .foregroundColor(.gray)
    }
}
