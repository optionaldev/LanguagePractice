//
// The LanguagePractice project.
// Created by optionaldev on 13/06/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

import UIKit

extension UICollectionView {
  
  func register<T: UICollectionViewCell>(cellType: T.Type) {
    register(T.self, forCellWithReuseIdentifier: "\(T.self)")
  }
  
  func dequeueReusable<T: UICollectionViewCell>(cellType: T.Type, indexPath: IndexPath) -> T {
    return dequeueReusableCell(withReuseIdentifier: "\(cellType)", for: indexPath) as! T
  }
}
