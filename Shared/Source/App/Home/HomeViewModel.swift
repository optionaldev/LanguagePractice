//
// The LanguagePractice project.
// Created by optionaldev on 02/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class    Combine.AnyCancellable

import protocol Foundation.ObservableObject

import struct   Foundation.Data
import struct   Foundation.Published


final class HomeViewModel: ObservableObject {
    
    init() {
        lexiconExists = Defaults.lexicon != nil
    }
    
    func requestAnyMissingItems() {
        if lexiconExists {
            startDownloadingImages()
        } else {
            LexiconsRequest().start {
                self.lexiconExists = true
                self.startDownloadingImages()
            }
        }
    }
    
    // TODO: Challenge such as pick challenge should initially be disabled
    // Once we get the lexicon, the button becomes enabled
    @Published var lexiconExists: Bool
    
    // MARK: - Private
    
    private var imagesToDownload: [String] = []
    private var imageCancellable: AnyCancellable?
    
    private func startDownloadingImages() {
        guard let lexicon = Defaults.lexicon else {
            log("Attempt ")
            return
        }
        log("start downloading images", type: .info)
        
        if let url = Persistence.imageFolderUrl {
            log("Download location: \"\(url)\"", type: .info)
        }
        
        imagesToDownload = lexicon.english.nouns
            .filter { $0.imageExists }
            .filter { Persistence.imagePath(id: $0.id) == nil }
            .map { $0.id }
        
        checkForImagesToDownload()
    }
    
    // TODO: Investigate how we can improve how fast the user gets to see images
    // 1.0) Add some images with the app launch, enough for the first few challenges
    // 1.1) User might never have internet, so 1.0 might still not be enough
    // 2.0) Download based on how the current challenge words have been shuffled
    // 3.0) Prepare shuffle first and then start image download
    private func checkForImagesToDownload() {
        if let imageID = imagesToDownload.last {
            downloadImage(id: imageID)
        } else {
            log("Finished downloading all images", type: .info)
        }
    }
    
    private func downloadImage(id: String) {
        guard let url = UrlBuilder.imageUrl(forID: id) else {
            log("Unable to get URL for id = \"\(id)\"", type: .unexpected)
            return
        }
        
        imageCancellable = Network.fetchImageData(from: url).sink(receiveCompletion: { error in
            log(error)
        }, receiveValue: { (data: Data) in
            Persistence.write(word: id, imageData: data)
            self.imagesToDownload.removeLast()
            self.checkForImagesToDownload()
        })
    }
}
