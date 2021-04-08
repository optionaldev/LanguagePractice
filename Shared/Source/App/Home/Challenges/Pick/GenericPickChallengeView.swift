//
// The LanguagePractice project.
// Created by optionaldev on 04/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

protocol ViewModelProtocol: ObservableObject {

    associatedtype Entry = EntryProtocol
    
    init(entries: [Entry])
    
    var history: [PickChallenge] { get }
    var wordsLearned: [String] { get }
    
    func inputTapped()
    func chose(index: Int)
}

struct GenericPickChallengeView<ViewModel: ViewModelProtocol>: View {
    
    var body: some View {
        GenericPickChallengeBody(viewModel: viewModel) { challenge in
            challengeView(challenge: challenge)
        }
    }
    
    // MARK: - Private
    
    @ObservedObject var viewModel: ViewModel
    
    private let imageCache = ImageCache()
    private let waveformImage = Image(systemName: "waveform.circle")
    
    @ViewBuilder
    private func challengeView(challenge: PickChallenge) -> some View {
        // TODO: Find a better way do macros with declarative statements
        #if os(iOS)
        VStack {
            inputView(rep: challenge.inputRepresentation)
                .frame(height: 200)
                .frame(maxWidth: Canvas.width - 10)
                .background(Color.orange.opacity(0.5))
                .cornerRadius(5)
            pickChallengeOutput(outputType: challenge.outputType, representations: challenge.outputRepresentations)
                .frame(maxWidth: Canvas.width - 10, maxHeight: .infinity)
                .padding(0)
        }
        .frame(width: Canvas.width)
        .background(Color.green.opacity(0.3))
        #else
        HStack {
            inputView(rep: challenge.inputRepresentation)
                .frame(width: 390, height: 290)
                .background(Color.orange.opacity(0.5))
                .cornerRadius(5)
                .padding(5)
            pickChallengeOutput(outputType: challenge.outputType, representations: challenge.outputRepresentations)
                .frame(width: 300, height: 300)
                .padding(0)
        }
        .background(Color.green.opacity(0.3))
        #endif
    }
    
    enum Signal {
        case input
        case output
    }
    
    @ViewBuilder
    private func viewForImage(withRepresentation rep: ImageRep, signal: Signal) -> some View {
        if let customImage = imageCache.image(forID: rep.imageID) {
            Image(customImage: customImage)
                .resizable()
                .cornerRadius(5)
        } else {
            // Should never end up on the else branch, but just in case
            Text(rep.imageID.removingDigits())
        }
    }
    
    // MARK: - Input
    
    @ViewBuilder
    private func inputView(rep: Rep) -> some View {
        switch rep {
        case .voice:
            waveformImage
                .resizable()
                .frame(width: 50, height: 50)
                .onTapGesture {
                    viewModel.inputTapped()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        viewModel.inputTapped()
                    }
                }
        case .textWithTranslation(let rep):
            VStack {
                Text(" ")
                Text(rep.text)
                    .font(.system(size: 30))
                Text(rep.translation)
                    .opacity(AppConstants.defaultOpacity)
            }
        case .simpleText(let rep):
            Text(rep.text)
                .font(.system(size: 30))
        case .textWithFurigana(let rep):
            textWithFurigana(representation: rep)
                .background(Color.blue.opacity(0.5))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(5)
        case .image(let rep):
            viewForImage(withRepresentation: rep, signal: .output)
        }
    }
    
    private func textWithFurigana(representation: TextWithFuriganaRep) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<representation.text.count, id: \.self) { index in
                VStack(alignment: .center, spacing: 0) {
                    if representation.furigana.isEmpty == false {
                        Text(representation.furigana[index])
                            .foregroundColor(Color.black)
                            .font(.system(size: 15))
                            .opacity(AppConstants.defaultOpacity)
                            .background(Color.blue.opacity(0.3))
                    }
                    Text("\(representation.text[index])")
                        .font(.system(size: 30))
                        .padding(.bottom, 5)
                        .background(Color.green.opacity(0.3))
                }
                .background(Color.purple.opacity(0.3))
            }
        }
    }
    
    // MARK: - Output
    
    private func pickChallengeOutput(outputType: ChallengeType, representations: [Rep]) -> some View {
        MatrixView(columns: 2, rows: 3) { index in
            Button {
                viewModel.chose(index: index)
            } label: {
                outputContent(forRepresentation: representations[index])
                    .contentShape(Rectangle())
                    .padding(0)
                    .background(Color.blue.opacity(0.5))
                    .cornerRadius(5)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func outputContent(forRepresentation representation: Rep) -> some View {
        switch representation {
        case .image(let rep):
            viewForImage(withRepresentation: rep, signal: .output)
        case .voice:
            waveformImage
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding(10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue.opacity(0.5))
                .cornerRadius(5)
        case .textWithTranslation(let rep):
            Text(rep.text)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .font(.system(size: 25))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue.opacity(0.5))
                .cornerRadius(5)
        case .textWithFurigana(let rep):
            textWithFurigana(representation: rep)
                .background(Color.blue.opacity(0.5))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(5)
        case .simpleText(let rep):
            Text(rep.text)
                .font(.system(size: 20))
                .background(Color.blue.opacity(0.5))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(5)
        }
    }
}

#if DEBUG
import SwiftUI
#endif

