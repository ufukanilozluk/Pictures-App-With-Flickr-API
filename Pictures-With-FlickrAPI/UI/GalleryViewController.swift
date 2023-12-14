import ImageSlideshow
import SkeletonView
import UIKit

/// View controller responsible for displaying a gallery of photos.
final class GalleryViewController: UIViewController {
  // MARK: - Outlets

  /// Collection view displaying the gallery of photos.
  @IBOutlet private weak var galleryCollectionView: UICollectionView!
  /// Button used to load more photos.
  @IBOutlet private weak var loadMoreButton: UIButton!
  // MARK: - Properties
  /// Current page number for photo retrieval.
  private var currentPage: Int = 1
  /// Data structure representing the current batch of photos.
  private var currentPhotoBatch: GalleryData.Photos?
  /// Total number of pages available for photo retrieval.
  private var totalPages: Int?
  /// Array containing the fetched photos.
  private var photos: [GalleryData.Photos.Photo] = []
  /// View model responsible for managing photo-related data.
  private let viewModel = PhotosViewModel()
  /// Flag to ensure skeleton animation is displayed only once.
  private var skeletonJustOnce = true
  /// Refresh control for the pull-to-refresh feature.
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
    if skeletonJustOnce {
      view.addSkeleton()
      skeletonJustOnce = false
    }
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
    viewModel.getPics(page: String(page)) {[weak self] result in
      switch result {
      case .success:
        DispatchQueue.main.async {
          self?.updateUI()
        }
      case let .failure(error):
        self?.showAlert(title: "Error", message: error.localizedDescription)
        self?.loadMoreButton.isHidden = true
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
    setBindings()
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
  // MARK: - SkeletonView Methods

  // These two methods are for skeletonview to work on UICollectionView
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
