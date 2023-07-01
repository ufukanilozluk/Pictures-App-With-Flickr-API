import ImageSlideshow
import SkeletonView
import UIKit

final class GalleryViewController: UIViewController {
  @IBOutlet var galleryCollectionView: UICollectionView!

  @IBOutlet weak var loadButton: UIButton!
  var currentPage: Int = 1
  var currentPhotoBatch: GalleryData.Photos?
  var totalPages: Int?
  var photos: [GalleryData.Photos.Photo] = []
  lazy var refreshControl = UIRefreshControl()
  let viewModel = PhotosViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchData(for: currentPage)
  }

  @IBAction func loadMore(_ sender: Any) {
    if currentPage < totalPages! {
      currentPage += 1
      fetchData(for: currentPage)
    }
  }


  func setBindings() {
    viewModel.errorMessage.bind { [weak self] error in
    if let errorMessage = error {
      self?.showAlert(title: "Error", message: errorMessage)
      return
    }
    }
    viewModel.photos.bind { [weak self] pics in
      guard let pics = pics else { return }
      self?.currentPhotoBatch = pics
      self?.totalPages = pics.pages
      self?.currentPage = Int(pics.page)!
      self?.photos += pics.photo
    }
  }

  @objc private func didPullToRefresh() {
    photos = []
    currentPage = 1
    loadButton.isHidden = false
    fetchData(for: currentPage)
    addSkeleton()
  }

    func fetchData(for page: Int) {
      viewModel.getPics(page: String(page)) {
        DispatchQueue.main.async {
          self.updateUI()
        }
      }
    }

  func configUI() {
    configureCollectionCellSize()
    galleryCollectionView.delegate = self
    galleryCollectionView.dataSource = self
    addSkeleton()
    refreshControl.attributedTitle = NSAttributedString(string: "Updating")
    refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    galleryCollectionView.addSubview(refreshControl)
  }

  func configureCollectionCellSize() {
    let width = view.frame.size.width
    let layout = galleryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.itemSize = CGSize(width: width, height: width)
  }

  func updateUI() {
    setBindings()
    galleryCollectionView.reloadData()
    refreshControl.endRefreshing()
    removeSkeleton()
    if currentPage == totalPages {
      loadButton.isHidden = true
    }
  }
  // To add and remove indicator
  func addSkeleton() {
    galleryCollectionView.showAnimatedGradientSkeleton()
  }
  func removeSkeleton() {
    galleryCollectionView.hideSkeleton()
  }
}

extension GalleryViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource {
  func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
    GalleryCollectionViewCell.reuseIdentifier
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    photos.count
  }
// needed for indicator
  func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    photos.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier,
      for: indexPath
    )

// need to send self to display fullscreen mode
  if let cell = cell as? GalleryCollectionViewCell {
    let rowData = photos[indexPath.row]
    cell.set(data: rowData, indexPath: indexPath, parentVC: self)
  }
    return cell
  }
}
