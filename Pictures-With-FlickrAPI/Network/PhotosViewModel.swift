import ImageSlideshow

/// View model responsible for managing photos data.
final class PhotosViewModel {
  /// Observable value holding the photos data.
  let photos: ObservableValue<GalleryData.Photos?> = ObservableValue(nil)

  /// Retrieves photos data from the API.
  ///
  /// - Parameters:
  ///   - page: The page of photos to retrieve.
  ///   - closure: A closure to be executed after the API call is completed.
  func getPics(page: String, closure: @escaping (Result<(), Error>) -> Void) {
    let endPoint = Endpoint.gallery(page: page)
    APIManager.shared.getJSON(url: endPoint.url) { (result: Result<GalleryData, APIManager.APIError>) in
      switch result {
      case let .success(pics):
        self.photos.value = pics.photos
        closure(.success(()))
      case let .failure(error):
        closure(.failure(error))
      }
    }
  }
}
