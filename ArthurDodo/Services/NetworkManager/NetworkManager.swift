import Foundation

final class NetworkManager {

    // MARK: - Properties
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    // MARK: - Init
    init(decoder: JSONDecoder, encoder: JSONEncoder) {
        self.decoder = decoder
        self.encoder = encoder
    }

    // MARK: - Methods

    // Это базовый get-запрос с использованием дженериков, которым мы потом будем использовать в конкретной реализации
    func fetchData<T: Codable>(_ typeOfData: endPoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = typeOfData.url else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }

        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed(error)))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }

            guard httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.httpError(httpResponse.statusCode)))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }

            do {
                let fetchedData = try self.decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(fetchedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decodingError(error)))
                }
            }
        }
        task.resume()
    }


    // Это put-запрос чтобы отправить новый адрес на сервер
    func updateUserAddress(_ address: Address, completion: @escaping (Result<Address, NetworkError>) -> Void) {
        guard let url = endPoint.userAddress.getURL(with: address.userId) else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.put.rawValue
        request.setValue(HTTPHeader.Value.json, forHTTPHeaderField: HTTPHeader.Field.contentType)

        do {
            let data = try self.encoder.encode(address)
            request.httpBody = data
        } catch {
            completion(.failure(.decodingError(error)))
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed(error)))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }

            guard httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.httpError(httpResponse.statusCode)))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }

            do {
                let fetchedData = try self.decoder.decode(Address.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(fetchedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decodingError(error)))
                }
            }
        }
        task.resume()
    }
}
