//
// The LanguagePractice project.
// Created by optionaldev on 11/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

extension Array where Element: Equatable {
  
  func appending(_ element: Element) -> [Element] {
    var result = self
    result.append(element)
    return result
  }
  
  mutating func removing(_ element: Element) {
    self = filter { $0 != element }
  }
  
  func without(_ element: Element) -> [Element] {
    return self.filter { $0 != element }
  }
}

extension Array where Element: Hashable {
  
  func removingDuplicates() -> Array {
    var array = Array()
    var set = Set<Element>()
    for elem in self where !array.contains(elem) {
      array.append(elem)
      set.insert(elem)
    }
    return array
  }
  
  /** Returns elements in `self` that are */
  func difference(from other: [Element]) -> [Element] {
    return Array(Set(self).symmetricDifference(Set(other)))
  }
}

extension Array where Element == Double {
  
  var challengeAverage: Double {
    return suffix(3).reduce(0, +) / 3
  }
}
