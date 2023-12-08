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
