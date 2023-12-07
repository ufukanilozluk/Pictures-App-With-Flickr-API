import ImageSlideshow
import SkeletonView
import UIKit

/// View controller responsible for displaying a gallery of photos.
final class GalleryViewController: UIViewController {
  // MARK: - Outlets

  @IBOutlet private weak var galleryCollectionView: UICollectionView!
  @IBOutlet private weak var loadMoreButton: UIButton!

  // MARK: - Properties

  private var currentPage: Int = 1
  private var currentPhotoBatch: GalleryData.Photos?
  private var totalPages: Int?
  private var photos: [GalleryData.Photos.Photo] = []
  private let viewModel = PhotosViewModel()
  private lazy var refreshControl: UIRefreshControl = {
    let control = UIRefreshControl()
    control.attributedTitle = NSAttributedString(string: "Updating")
    control.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    return control
  }()

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    view.addSkeleton()
  }

  // MARK: - Actions

  /// Loads more photos when the "Load More" button is pressed.
  @IBAction private func btnLoadMore(_ sender: Any) {
    loadMore()
  }

  // MARK: - Helper Methods

  /// Sets up data bindings for view model properties.
  private func setBindings() {
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
    loadMoreButton.isHidden = false
    fetchData(for: currentPage)
  }

  /// Fetches photos for a specific page.
  /// - Parameter page: The page number to fetch.
  private func fetchData(for page: Int) {
    viewModel.getPics(page: String(page)) { result in
      switch result {
      case .success:
        DispatchQueue.main.async {
          self.updateUI()
        }
      case let .failure(error):
        self.showAlert(title: "Error", message: error.localizedDescription)
        self.loadMoreButton.isHidden = true
      }
    }
  }

  /// Configures the UI elements.
  private func configUI() {
    configureCollectionCellSize()
    galleryCollectionView.delegate = self
    galleryCollectionView.dataSource = self
    galleryCollectionView.addSubview(refreshControl)
  }

  /// Initiliazes everything
  private func setup() {
    configUI()
    fetchData(for: currentPage)
  }

  /// Configures the size of collection view cells based on the view width.
  private func configureCollectionCellSize() {
    if let layout = galleryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      let width = view.frame.size.width
      layout.itemSize = CGSize(width: width, height: width)
    }
  }

  /// Updates the UI after data is fetched.
  private func updateUI() {
    setBindings()
    galleryCollectionView.reloadData()
    refreshControl.endRefreshing()
    view.removeSkeleton()
    if currentPage == totalPages {
      loadMoreButton.isHidden = true
    }
  }
}

// MARK: - UICollectionViewDelegate and SkeletonCollectionViewDataSource

extension GalleryViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource {
  // MARK: - SkeletonCollectionViewDataSource Methods

  func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
    GalleryCollectionViewCell.reuseIdentifier
  }

  func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    2
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
