import ImageSlideshow
import SkeletonView
import UIKit

/// View controller responsible for displaying a gallery of photos.
final class GalleryViewController: UIViewController {
  // MARK: - Outlets

  @IBOutlet var galleryCollectionView: UICollectionView!
  @IBOutlet weak var loadButton: UIButton!

  // MARK: - Properties

  var currentPage: Int = 1
  var currentPhotoBatch: GalleryData.Photos?
  var totalPages: Int?
  var photos: [GalleryData.Photos.Photo] = []
  lazy var refreshControl = UIRefreshControl()
  let viewModel = PhotosViewModel()

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchData(for: currentPage)
  }
  // MARK: - Actions

  /// Loads more photos when the "Load More" button is pressed.
  @IBAction func btnLoadMore(_ sender: Any) {
    loadMore()
  }

  // MARK: - Helper Methods

  /// Sets up data bindings for view model properties.
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
      if let currentPage = Int(pics.page) {
        self?.currentPage = currentPage
      }
      self?.photos += pics.photo
    }
  }

  /// Loads more pics
  private func loadMore() {
    if let totalPages = totalPages {
      if currentPage < totalPages {
        currentPage += 1
        fetchData(for: currentPage)
      }
    }
  }
  // MARK: - UI and Data Handling

  /// Handles the "Pull to Refresh" action.
  @objc private func didPullToRefresh() {
    photos = []
    currentPage = 1
    loadButton.isHidden = false
    fetchData(for: currentPage)
    addSkeleton()
  }

  /// Fetches photos for a specific page.
  /// - Parameter page: The page number to fetch.
  func fetchData(for page: Int) {
    viewModel.getPics(page: String(page)) {_ in
      DispatchQueue.main.async {
        self.updateUI()
      }
    }
  }

  /// Configures the UI elements.
  func configUI() {
    configureCollectionCellSize()
    galleryCollectionView.delegate = self
    galleryCollectionView.dataSource = self
    addSkeleton()
    refreshControl.attributedTitle = NSAttributedString(string: "Updating")
    refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    galleryCollectionView.addSubview(refreshControl)
  }

  /// Configures the size of collection view cells based on the view width.
  func configureCollectionCellSize() {
    if let layout = galleryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      let width = view.frame.size.width
      layout.itemSize = CGSize(width: width, height: width)
    }
  }

  /// Updates the UI after data is fetched.
  func updateUI() {
    setBindings()
    galleryCollectionView.reloadData()
    refreshControl.endRefreshing()
    removeSkeleton()
    if currentPage == totalPages {
      loadButton.isHidden = true
    }
  }

  /// Adds a skeleton loading animation to the collection view.
  func addSkeleton() {
    galleryCollectionView.showAnimatedGradientSkeleton()
  }

  /// Removes the skeleton loading animation from the collection view.
  func removeSkeleton() {
    galleryCollectionView.hideSkeleton()
  }
}

// MARK: - UICollectionViewDelegate and SkeletonCollectionViewDataSource

extension GalleryViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource {
  // MARK: - SkeletonCollectionViewDataSource Methods

  func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
    GalleryCollectionViewCell.reuseIdentifier
  }

  func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    photos.count
  }

  // MARK: - UICollectionViewDelegate Methods

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    photos.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier,
      for: indexPath
    )

    if let cell = cell as? GalleryCollectionViewCell {
      let rowData = photos[indexPath.row]
      cell.set(data: rowData, indexPath: indexPath, parentVC: self)
    }
    return cell
  }
}
