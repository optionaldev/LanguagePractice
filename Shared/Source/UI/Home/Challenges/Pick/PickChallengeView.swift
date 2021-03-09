//
// The LanguagePractice project.
// Created by optionaldev on 08/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.View


import struct SwiftUI.PageTabViewStyle
import struct SwiftUI.TabView
import struct SwiftUI.Text
import struct SwiftUI.ObservedObject

struct PickChallengeView: View {
    
    var body: some View {
        Text("Pick Challenge")
    }
    
    @ObservedObject var viewModel = PickChallengeViewModel()
}
