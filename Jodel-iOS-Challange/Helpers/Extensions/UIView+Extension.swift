//
//  UIView+Extension.swift
//  Jodel-iOS-Challange
//
//  Created by Ufuk Anıl Özlük on 28.11.2023.
//

import Foundation
import UIKit
import SkeletonView

  /// Methods for skeletonView
extension UIView {
  /// Adds a skeleton loading animation to the collection view.
  func addSkeleton() {
    self.showAnimatedGradientSkeleton()
  }

  /// Removes the skeleton loading animation from the collection view.
  func removeSkeleton() {
    self.hideSkeleton()
  }
}
