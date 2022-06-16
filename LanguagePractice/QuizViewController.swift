//
// The LanguagePractice project.
// Created by optionaldev on 16/06/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

import SwiftAnchoring
import UIKit

final class QuizViewController: BaseViewController, UICollectionViewDataSource {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let inputBackground = view.addingSubview(UIView.self)
    
    // TODO: Fix aspect ratio based on image sizes
    inputBackground.anchor(.top, with: view, safe: true)
    inputBackground.anchor(.left(10), .right(10), with: view)
    inputBackground.shape(.height(200))
    
    view.backgroundColor = .white
    
    inputBackground.backgroundColor = .red.withAlphaComponent(0.2)
    inputBackground.layer.cornerRadius = 10
    
    inputLabel = inputBackground.addingSubview(UILabel.self)
    inputLabel.text = "Test"
    inputLabel.anchor(.center, with: inputBackground)
    
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: (Screen.width / 2) - 20, height: 100)

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    outputCollectionView = view.addingSubview(collectionView)

    collectionView.anchor(.topToBottom(10), with: inputBackground)
    collectionView.anchor(.left(10), .right(10), .bottom(10), with: view)
    collectionView.dataSource = self
    collectionView.register(cellType: QuizOutputCell.self)
  }
  
  // MARK: - UICollectionViewDataSource
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusable(cellType: QuizOutputCell.self, indexPath: indexPath)
    
    cell.setup(with: "\(indexPath.row)")
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 6
  }
  
  // MARK: - Private
  
  private weak var inputLabel: UILabel!
  private weak var outputCollectionView: UICollectionView!
}
