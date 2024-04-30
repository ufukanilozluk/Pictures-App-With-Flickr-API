import Foundation

/// This structure holds the necessary information for an API request.
struct Endpoint {
  /// Represents the host name of the API server (e.g., "api.example.com").
  var host: String
  /// Represents the path of the API request (e.g., "/api/resource").
  var path: String
  /// An array containing query items for the API request.
  var queryItems: [URLQueryItem] = []

  /// Adds a query item to the Endpoint structure.
  ///
  /// - Parameters:
  ///   - name: The name of the query item.
  ///   - value: The value of the query item.
  mutating func addQueryItem(name: String, value: String) {
    queryItems.append(URLQueryItem(name: name, value: value))
  }

  /// Returns the Endpoint structure as a complete URL.
  ///
  /// - Returns: The full URL of the Endpoint.
  var url: URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = host
    components.path = "/\(path)"
    components.queryItems = queryItems

    guard let url = components.url else {
      fatalError("Invalid URL components: \(components)")
    }
    return url
  }
}

extension Endpoint {
  /// Constructs an endpoint for gallery URL.
  ///
  /// - Parameters:
  ///   - method: The API method for fetching gallery photos (default: "flickr.galleries.getPhotos").
  ///   - apiKey: The API key for authentication (default: "92111faaf0ac50706da05a1df2e85d82").
  ///   - galleryId: The ID of the gallery to retrieve photos from (default: "66911286-72157647277042064").
  ///   - format: The response format (default: "json").
  ///   - perPage: The number of photos per page (default: "3").
  ///   - noJsonCallBack: A flag indicating whether to exclude the JSON callback (default: "1").
  ///   - page: The page number (default: "1").
  ///
  /// - Returns: An Endpoint instance representing the constructed gallery URL.
  static func gallery(
    method: String = "flickr.galleries.getPhotos",
    apiKey: String = "YOUR API KEY",
    galleryId: String = "66911286-72157647277042064",
    format: String = "json",
    perPage: String = "3",
    noJsonCallBack: String = "1",
    page: String = "1"
  ) -> Self {
    Endpoint(
      host: "api.flickr.com",
      path: "services/rest/",
      queryItems: [
        URLQueryItem(name: "method", value: method),
        URLQueryItem(name: "api_key", value: apiKey),
        URLQueryItem(name: "gallery_id", value: galleryId),
        URLQueryItem(name: "format", value: format),
        URLQueryItem(name: "nojsoncallback", value: noJsonCallBack),
        URLQueryItem(name: "per_page", value: perPage),
        URLQueryItem(name: "page", value: page)
      ]
    )
  }
}
