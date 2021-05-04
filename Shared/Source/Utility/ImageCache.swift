//
// The LanguagePractice project.
// Created by optionaldev on 23/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.EnvironmentKey

import struct SwiftUI.EnvironmentValues

#if os(iOS)
import class UIKit.UIImage
typealias CustomImage = UIImage
#else
import class AppKit.NSImage
typealias CustomImage = NSImage
#endif


final class ImageCache {
    
    var images: [String: CustomImage] = [:]
    
    func image(forID id: String) -> CustomImage? {
        if let cachedImage = images[id] {
            log("returning cached image", type: .info)
            return cachedImage
        }
        if let imageData = Persistence.imageData(forID: id) {
            guard let uiImage = CustomImage(data: imageData) else {
                log("Unable to create UIImage from path: \"\(Persistence.imagePath(id: id) ?? "<unknown>") \"", type: .unexpected)
                return nil
            }
            images[id] = uiImage
            log("returning normal image", type: .info)
            return uiImage
        }
        
        log("Path \"\(String(describing: Persistence.imagePath(id: id)))\" doesn't exist, but we shouldn't have created a challenge with image type", type: .unexpected)
        return nil
    }
}

struct ImageCacheKey: EnvironmentKey {

    static let defaultValue = ImageCache()
}

extension EnvironmentValues {

    var imageCache: ImageCache {
        get {
            self[ImageCacheKey.self]
        }
        set {
            self[ImageCacheKey.self] = newValue
        }
    }
}
