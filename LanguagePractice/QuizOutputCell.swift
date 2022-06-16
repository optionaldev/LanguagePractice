//
// The LanguagePractice project.
// Created by optionaldev on 16/06/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

import SwiftAnchoring
import UIKit

final class QuizOutputCell: UICollectionViewCell {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    label = addingSubview(UILabel.self)
    label.anchor(.center, with: self)
    
    layer.cornerRadius = 10
    backgroundColor = .blue.withAlphaComponent(0.2)
  }
  
  func setup(with id: String) {
    label.text = id
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private
  
  private var label: UILabel!
}
