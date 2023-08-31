import ImageSlideshow
import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
  @IBOutlet var title: UILabel!
  @IBOutlet var picture: ImageSlideshow!
  weak var parentViewController: UIViewController?
  static let reuseIdentifier: String = "GalleryCell"

  func set(data: GalleryData.Photos.Photo, indexPath: IndexPath, parentVC: UIViewController) {
    title.text = data.title
    addPics(url: data.photoURL, on: picture)
    parentViewController = parentVC
  }

  func addPics(url: String, on view: ImageSlideshow) {
    guard let alamofireSource = AlamofireSource(urlString: url) else {
      return
    }
      let alamofireSourceArray: [AlamofireSource] = [alamofireSource]
      view.setImageInputs(alamofireSourceArray)
      view.contentScaleMode = UIView.ContentMode.scaleToFill
      // tap to view in fullscreen
      let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
      picture.addGestureRecognizer(gestureRecognizer)
  }

  @objc func didTap() {
    guard let parentViewController = parentViewController else { return }
    picture.presentFullScreenController(from: parentViewController)
  }
}
