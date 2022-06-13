//
// The LanguagePractice project.
// Created by optionaldev on 13/06/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

import UIKit

final class HomeCell: UICollectionViewCell {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    label = addingSubview(UILabel.self)
    label.anchor(.left(20), .centerY, with: self)
  }
  
  func setup(with entryType: EntryType) {
    label.text = entryType.title
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private
  
  private var label: UILabel!
}
