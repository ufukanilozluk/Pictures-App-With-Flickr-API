import Foundation

/// Represents a response that can be cached.
class CachableResponse: Codable {
  /// The data of the response.
  let data: Data
  /// The timestamp when the response was received.
  let timestamp: Date
  /// The date when the cached response will expire.
  let expireDate: Date

  /// Initializes a `CachableResponse`.
  ///
  /// - Parameters:
  ///   - data: The data of the response.
  ///   - timestamp: The timestamp when the response was received.
  ///   - expireDate: The date when the cached response will expire.
  init(data: Data, timestamp: Date, expireDate: Date) {
    self.data = data
    self.timestamp = timestamp
    self.expireDate = expireDate
  }
}

/// A manager for handling API requests and caching responses.

class APIManager {
  /// Shared instance of `APIManager`.
  static let shared = APIManager()
  /// Private initializer to prevent external initialization.
  private init() {}
  /// Cache for storing responses.
  private let cache = NSCache<NSString, CachableResponse>()
  /// The time interval after which a cached response will expire (in seconds).
  private let cacheExpirationInterval: TimeInterval = 3600

  /// Performs a GET request and decodes the JSON response.
  ///
  /// - Parameters:
  ///   - url: The URL for the API endpoint.
  ///   - dateDecodingStrategy: The date decoding strategy for JSON decoding. Defaults to `.deferredToDate`.
  ///   - keyDecodingStrategy: The key decoding strategy for JSON decoding. Defaults to `.useDefaultKeys`.
  ///   - completion: A closure to be executed once the request is complete.
  func getJSON<T: Decodable>(
    url: URL,
    dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
    keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
    completion: @escaping (Result<T, APIError>) -> Void
  ) {
    if let cachedResponse = getCachedResponse(for: url),
      let decodedData = decodeResponse(type: T.self, from: cachedResponse.data) {
      completion(.success(decodedData))
      return
    }

    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      if let error = error {
        completion(.failure(APIError.networkError(error.localizedDescription)))
        return
      }
      guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else {
        completion(.failure(APIError.invalidResponse))
        return
      }
      guard let data = data else {
        completion(.failure(APIError.noData))
        return
      }
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = dateDecodingStrategy
      decoder.keyDecodingStrategy = keyDecodingStrategy
      do {
        let decodedData = try decoder.decode(T.self, from: data)
        let cachableResponse = CachableResponse(
        data: data,
        timestamp: Date(),
        expireDate: Date().addingTimeInterval(self?.cacheExpirationInterval ?? 0))
        self?.cacheResponse(cachableResponse, for: url)
        completion(.success(decodedData))
      } catch let decodingError {
        completion(.failure(APIError.decodingFailed(decodingError.localizedDescription)))
      }
    }
    .resume()
  }

  /// Decodes a response from JSON data.
  ///
  /// - Parameters:
  ///   - type: The type to decode to.
  ///   - data: The data to decode from.
  /// - Returns: An instance of the decoded type, or `nil` if decoding fails.
  func decodeResponse<T: Decodable>(type: T.Type, from data: Data) -> T? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(T.self, from: data)
      return decodedData
    } catch {
      return nil
    }
  }
}

// MARK: Cache Methods

extension APIManager {
  /// Retrieves a cached response for a given URL.
  ///
  /// - Parameter url: The URL to retrieve the cached response for.
  /// - Returns: The cached response, if available.
  func getCachedResponse(for url: URL) -> CachableResponse? {
    return cache.object(forKey: url.absoluteString as NSString)
  }

  /// Caches a response for a given URL.
  ///
  /// - Parameters:
  ///   - response: The response to cache.
  ///   - url: The URL for which to cache the response.
  func cacheResponse(_ response: CachableResponse, for url: URL) {
    cache.setObject(response, forKey: url.absoluteString as NSString)
  }

/// Clears the entire cache.
  func clearCache() {
    cache.removeAllObjects()
  }
}

// MARK: Error Enum


extension APIManager {
/// Represents errors that can occur during API operations.
  enum APIError: Error {
    /// A network-related error with an associated message.
    case networkError(String)
    /// An error indicating that the response was not valid.
    case invalidResponse
    /// An error indicating that the request failed with an associated status code.
    case requestFailed(Int)
    /// An error indicating that no data was returned from the request.
    case noData
    /// An error indicating that decoding of the response failed with an associated message.
    case decodingFailed(String)

/// A localized description of the error.
  var localizedDescription: String {
    switch self {
    case .networkError(let errorString):
      return "Network Error: \(errorString)"
    case .invalidResponse:
      return "Invalid Response Error"
    case .requestFailed(let statusCode):
      return "Request Failed Error: \(statusCode)"
    case .noData:
      return "No Data Error"
    case .decodingFailed(let errorString):
      return "Decoding Error: \(errorString)"
    }
  }
  }
}
