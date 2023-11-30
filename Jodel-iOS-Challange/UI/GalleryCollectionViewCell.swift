import ImageSlideshow
import UIKit

/// Custom `UICollectionViewCell` for displaying a gallery item.
class GalleryCollectionViewCell: UICollectionViewCell {
  /// The label for displaying the title of the gallery item.
  @IBOutlet var titleLabel: UILabel!
  /// The slideshow view for displaying images.
  @IBOutlet var pictureView: ImageSlideshow!
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
    titleLabel.text = data.title
    addPics(url: data.photoURL, on: pictureView)

    parentViewController = parentVC
  }

  /// Adds pictures to the slideshow view from the provided URL.
  ///
  /// - Parameters:
  ///   - url: The URL of the image.
  ///   - view: The `ImageSlideshow` view.
  private func addPics(url: String, on view: ImageSlideshow) {
    setupSlideshow(with: url, on: view)
  }

  /// Setup the slideshow with the given URL.
  ///
  /// - Parameters:
  ///   - url: The URL of the image.
  ///   - view: The `ImageSlideshow` view to display the image.
  private func setupSlideshow(with url: String, on view: ImageSlideshow) {
    guard let alamofireSource = createAlamofireSource(from: url) else {
      addNoImageView(view)
      return
    }

    let alamofireSourceArray: [AlamofireSource] = [alamofireSource]
    view.setImageInputs(alamofireSourceArray)
    view.contentScaleMode = UIView.ContentMode.scaleToFill
    addTapGesture()
  }

  /// Create an AlamofireSource from the given URL.
  ///
  /// - Parameter url: The URL of the image.
  /// - Returns: An AlamofireSource object if the URL is valid, otherwise nil.
  private func createAlamofireSource(from url: String) -> AlamofireSource? {
    guard let imageURL = URL(string: url) else {
      return nil
    }
    return AlamofireSource(url: imageURL)
  }

  /// Add a default noimage view to the given ImageSlideshow.
  ///
  /// - Parameter view: The `ImageSlideshow` view to which the noimage view will be added.
  private func addNoImageView(_ view: ImageSlideshow) {
    let noImageView = UIImageView(image: UIImage(named: "noimage"))
    view.addSubview(noImageView)
    noImageView.translatesAutoresizingMaskIntoConstraints = false
    noImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    noImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }


  /// Adds a tap gesture recognizer for full-screen viewing.
  private func addTapGesture() {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
    pictureView.addGestureRecognizer(gestureRecognizer)
  }

  /// Action to perform when the slideshow view is tapped.
  @objc private func didTap() {
    guard let parentViewController = parentViewController else { return }
    pictureView.presentFullScreenController(from: parentViewController)
  }

  /// Deinitialize the object and release any resources.
  deinit {
    parentViewController = nil
  }

}
