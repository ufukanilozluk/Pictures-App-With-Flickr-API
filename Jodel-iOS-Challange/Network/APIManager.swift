import Foundation

class CachableResponse: Codable {
  let data: Data
  let timestamp: Date
  let expireDate: Date

  init(data: Data, timestamp: Date, expireDate: Date) {
    self.data = data
    self.timestamp = timestamp
    self.expireDate = expireDate
  }
}

class APIManager {
  
  static let shared = APIManager()
  private init() {}
  
  

  private let cache = NSCache<NSString, CachableResponse>()
  private let cacheExpirationInterval: TimeInterval = 3600

  // MARK: API Methods
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
  func getCachedResponse(for url: URL) -> CachableResponse? {
    return cache.object(forKey: url.absoluteString as NSString)
  }

  func cacheResponse(_ response: CachableResponse, for url: URL) {
    cache.setObject(response, forKey: url.absoluteString as NSString)
  }

  func clearCache() {
    cache.removeAllObjects()
  }
}

// MARK: Error Enum

extension APIManager {
  enum APIError: Error {
    case networkError(String)
    case invalidResponse
    case requestFailed(Int)
    case noData
    case decodingFailed(String)

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
