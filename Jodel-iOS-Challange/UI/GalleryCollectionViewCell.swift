import ImageSlideshow
import UIKit

/// Custom `UICollectionViewCell` for displaying a gallery item.
class GalleryCollectionViewCell: UICollectionViewCell {
  /// The label for displaying the title of the gallery item.
  @IBOutlet var title: UILabel!

  /// The slideshow view for displaying images.
  @IBOutlet var picture: ImageSlideshow!

  /// Weak reference to the parent view controller to prevent strong reference cycles.
  weak var parentViewController: UIViewController?

  /// The reuse identifier for this cell.
  static let reuseIdentifier: String = "GalleryCell"

  /// Sets the data for the cell.
  ///
  /// - Parameters:
  ///   - data: The data of the gallery item.
  ///   - indexPath: The index path of the cell.
  ///   - parentVC: The parent view controller.
  func set(data: GalleryData.Photos.Photo, indexPath: IndexPath, parentVC: UIViewController) {
    title.text = data.title
    addPics(url: data.photoURL, on: picture)
    parentViewController = parentVC
  }

  /// Adds pictures to the slideshow view from the provided URL.
  ///
  /// - Parameters:
  ///   - url: The URL of the image.
  ///   - view: The `ImageSlideshow` view.
  func addPics(url: String, on view: ImageSlideshow) {
    guard let alamofireSource = AlamofireSource(urlString: url) else {
      return
    }
    let alamofireSourceArray: [AlamofireSource] = [alamofireSource]
    view.setImageInputs(alamofireSourceArray)
    view.contentScaleMode = UIView.ContentMode.scaleToFill

    // Add a tap gesture recognizer for full-screen viewing.
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
    picture.addGestureRecognizer(gestureRecognizer)
  }

  /// Action to perform when the slideshow view is tapped.
  @objc func didTap() {
    guard let parentViewController = parentViewController else { return }
    picture.presentFullScreenController(from: parentViewController)
  }
}
