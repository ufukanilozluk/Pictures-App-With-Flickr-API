import Foundation

struct Endpoint {
  var host: String
  var path: String
  var queryItems: [URLQueryItem] = []
}

extension Endpoint {
  var url: URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = host
    components.path = "/" + path
    components.queryItems = queryItems
    guard let url = components.url else {
      preconditionFailure(
        "Invalid URL components: \(components)"
      )
    }
  return url
  }
}



extension Endpoint {
  //  To construct endpoint for gallery URL
  //  URL Sample: api.flickr.com/services/rest/?method=flickr.galleries.getPhotos&api_key=APIKEY&gallery_id=66911286-72157647277042064&format=json&nojsoncallback=1
  static func gallery(
    method: String = "flickr.galleries.getPhotos",
    apiKey: String = "92111faaf0ac50706da05a1df2e85d82",
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
