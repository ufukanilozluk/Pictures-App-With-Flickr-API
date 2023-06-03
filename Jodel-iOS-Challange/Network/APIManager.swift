import Foundation

class APIManager {
  static let shared = APIManager()
  private init() {}

  func getJSON<T: Decodable>(
    url: URL,
    dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
    keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
    completion: @escaping (Result<T, APIError>) -> Void
  ) {
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(.networkError(error.localizedDescription)))
        return
      }
      guard let httpResponse = response as? HTTPURLResponse else {
        completion(.failure(.invalidResponse))
        return
      }
      guard (200...299).contains(httpResponse.statusCode) else {
        completion(.failure(.requestFailed(httpResponse.statusCode)))
        return
      }
      guard let data = data else {
        completion(.failure(.noData))
        return
      }
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = dateDecodingStrategy
      decoder.keyDecodingStrategy = keyDecodingStrategy
      print(url)
      do {
        let decodedData = try decoder.decode(T.self, from: data)
        completion(.success(decodedData))
        return
      } catch let decodingError {
//        print(String(describing: decodingError)) // Use this for debug
        completion(.failure(.decodingFailed(decodingError.localizedDescription)))
        return
      }
    }
    .resume()
  }
}

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
