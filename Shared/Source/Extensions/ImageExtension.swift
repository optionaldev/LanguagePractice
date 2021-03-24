//
// The LanguagePractice project.
// Created by optionaldev on 24/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import struct SwiftUI.Image

extension Image {
    
    init(customImage: CustomImage) {
        #if os(iOS)
        self.init(uiImage: customImage)
        #else
        self.init(nsImage: customImage)
        #endif
    }
}
