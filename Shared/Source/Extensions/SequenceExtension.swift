//
// The LanguagePractice project.
// Created by optionaldev on 23/03/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

import Foundation

extension Sequence where Iterator.Element: Equatable {
  var uniqueElements: [Iterator.Element] {
    return self.reduce([]) { uniqueElements, element in
      uniqueElements.contains(element) ? uniqueElements : uniqueElements + [element]
    }
  }
}
