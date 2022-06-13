//
// The LanguagePractice project.
// Created by optionaldev on 10/06/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

import SwiftAnchoring
import UIKit

final class HomeViewController: BaseViewController, UICollectionViewDataSource {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: UIScreen.width, height: 50)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    self.collectionView = view.addingSubview(collectionView)
    collectionView.anchor(.inner, with: view)
    collectionView.dataSource = self
    collectionView.register(cellType: HomeCell.self)
  }
  
  // MARK: - UICollectionViewDataSource conformance
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusable(cellType: HomeCell.self, indexPath: indexPath)
    
    cell.setup(with: EntryType.allCases[indexPath.row])
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return EntryType.allCases.count
  }
  
  // MARK: - Private
  
  /**
   Collection view holding the different types of challenges that appear on the home screen.
   */
  private var collectionView: UICollectionView!
}
