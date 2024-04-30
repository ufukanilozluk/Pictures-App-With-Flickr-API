import Foundation

/// Represents a response that can be cached.
class CachableResponse: Codable {
  /// The data associated with the response.
  let data: Data
  /// The timestamp indicating when the response was cached.
  let timestamp: Date
  /// The date when the cached response is set to expire.
  let expireDate: Date

  /// Initializes a new instance of the `CachableResponse` class.
  /// - Parameters:
  ///   - data: The data associated with the response.
  ///   - timestamp: The timestamp indicating when the response was cached.
  ///   - expireDate: The date when the cached response is set to expire.
  init(data: Data, timestamp: Date, expireDate: Date) {
    self.data = data
    self.timestamp = timestamp
    self.expireDate = expireDate
  }
}


/// A manager for handling API requests and caching responses.
///
/// 
class APIManager {
  // MARK: - Singleton Instance

  /// Shared instance of the APIManager.
  static let shared = APIManager()

  /// Private initializer to enforce singleton pattern.
  private init() {}

  // MARK: - Cache Properties

  /// NSCache used for caching responses.
  private let cache = NSCache<NSString, CachableResponse>()
  /// Expiration interval for cached responses (default is 1 hour).
  private let cacheExpirationInterval: TimeInterval = 3600

  // MARK: - API Request Method

  /// Performs a GET request for JSON data from the specified URL.
  /// - Parameters:
  ///   - url: The URL to request JSON data from.
  ///   - dateDecodingStrategy: Date decoding strategy for JSON decoding (default is .deferredToDate).
  ///   - keyDecodingStrategy: Key decoding strategy for JSON decoding (default is .useDefaultKeys).
  ///   - completion: Closure to be called upon completion with the result.
  func getJSON<T: Decodable>(
    url: URL,
    dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
    keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
    completion: @escaping (Result<T, APIError>) -> Void
  ) {
    // Check if the response is already cached.
    if let cachedResponse = getCachedResponse(for: url),
      let decodedData = decodeResponse(type: T.self, from: cachedResponse.data) {
      completion(.success(decodedData))
      return
    }

    // If not cached, perform a network request.
    let timeoutInterval: TimeInterval = 30
    let urlRequest = URLRequest(url: url, timeoutInterval: timeoutInterval)

    URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
      // Handle network errors.
      if let error = error as? URLError {
        switch error.code {
        case .notConnectedToInternet:
          completion(.failure(APIError.noInternetConnection))
        case .timedOut:
          completion(.failure(APIError.timeout))
        default:
          completion(.failure(APIError.networkError(error.localizedDescription)))
        }
        return
      }

      // Check for a valid HTTP response status code.
      guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else {
        completion(.failure(APIError.invalidResponse))
        return
      }

      // Ensure that data is present.
      guard let data = data else {
        completion(.failure(APIError.noData))
        return
      }

      // Decode the JSON data.
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = dateDecodingStrategy
      decoder.keyDecodingStrategy = keyDecodingStrategy

      do {
        let decodedData = try decoder.decode(T.self, from: data)
        let cachableResponse = CachableResponse(
          data: data,
          timestamp: Date(),
          expireDate: Date().addingTimeInterval(self?.cacheExpirationInterval ?? 0)
        )
        // Cache the response.
        self?.cacheResponse(cachableResponse, for: url)
        completion(.success(decodedData))
      } catch let decodingError {
        completion(.failure(APIError.decodingFailed(decodingError.localizedDescription)))
      }
    }
    .resume()
  }

  // MARK: - Response Decoding

  /// Decodes a response of the specified type from the provided data.
  /// - Parameters:
  ///   - type: The type to decode.
  ///   - data: The data to decode.
  /// - Returns: An instance of the decoded type or nil if decoding fails.
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

// MARK: - Cache Methods

extension APIManager {
  /// Retrieves a cached response for the specified URL.
  /// - Parameter url: The URL for which to retrieve a cached response.
  /// - Returns: The cached response or nil if not found.
  func getCachedResponse(for url: URL) -> CachableResponse? {
    return cache.object(forKey: url.absoluteString as NSString)
  }

  /// Caches the provided response for the specified URL.
  /// - Parameters:
  ///   - response: The response to cache.
  ///   - url: The URL for which to cache the response.
  func cacheResponse(_ response: CachableResponse, for url: URL) {
    cache.setObject(response, forKey: url.absoluteString as NSString)
  }

  /// Clears all cached responses.
  func clearCache() {
    cache.removeAllObjects()
  }
}

// MARK: - API Error Enum

extension APIManager {
  /// Enum representing various API-related errors.
  enum APIError: Error {
    case networkError(String)
    case invalidResponse
    case requestFailed(Int)
    case noData
    case decodingFailed(String)
    case noInternetConnection
    case timeout

    /// A localized description for each error case.
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
      case .noInternetConnection:
        return "No Internet Connection"
      case .timeout:
        return "Request Timeout"
      }
    }
  }
}
