/// Represents the gallery data containing photos.
struct GalleryData: Codable {
  /// The photos in the gallery.
  let photos: Photos
}

extension GalleryData {
  /// Represents the photos in a gallery.
  struct Photos: Codable {
    /// The current page number.
    let page: String
    /// The total number of pages.
    let pages: Int
    /// The number of photos per page.
    let perpage: String
    /// The total number of photos.
    let total: Int
    /// The photos in the gallery.
    let photo: [Photo]
  }
}

extension GalleryData.Photos {
  /// Represents a photo in the gallery.
  struct Photo: Codable {
    /// The ID of the photo.
    let id: String
    /// The secret key of the photo.
    let secret: String
    /// The server hosting the photo.
    let server: String
    /// The farm ID associated with the photo.
    let farm: Int
    /// The title of the photo.
    let title: String
    /// The URL of the photo.
    var photoURL: String {
      return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
  }
}
