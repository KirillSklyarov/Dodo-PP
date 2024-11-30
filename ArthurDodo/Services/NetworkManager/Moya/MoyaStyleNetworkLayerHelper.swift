import Foundation

protocol Endpoint {
    var schema: String { get }
    var host: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String] { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    var schema: String {
        "https"
    }

    var host: String {
        "localhost:3001"
    }
}

// Методы
enum MoyaHttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// Обработка ошибок
enum MoyaNetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case httpError(Int)
    case noData
    case decodingError(Error)
    case unauthorized
    case unexpectedStatusCode
    case unknown
}


//enum RequestError: Error {
//    case decode
//    case invalidURL
//    case noResponse
//    case unexpectedStatusCode
//    case unknown
//
//    var customMessage: String {
//        switch self {
//        case .decode:
//            return "Decode error"
//        case .unauthorized:
//            return "Session expired"
//        default:
//            return "Unknown error"
//        }
//    }
//}

