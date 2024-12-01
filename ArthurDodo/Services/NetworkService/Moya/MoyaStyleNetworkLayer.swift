import Foundation

final class MoyaStyleNetworkLayer {

    func sendRequest<T: Decodable>(endpoint: Endpoint, model: T.Type) async -> Result<T, MoyaNetworkError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.schema
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }

            switch response.statusCode {
            case 200..<300:
                guard let data = try? JSONDecoder().decode(T.self, from: data) else {
                    return .failure(.invalidResponse)
                }
                return .success(data)
            case 400..<500:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
