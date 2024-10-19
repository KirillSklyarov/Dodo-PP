//
//  NetworkManager.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 14.10.2024.
//

import Foundation

final class NetworkManager {

    static let shared = NetworkManager()
    private init() {}

    var addresses: [Address]?
}

// MARK: - CRUD
extension NetworkManager {
    func fetchData<T: Codable>(_ typeOfData: endPoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: typeOfData.rawValue) else {
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
                let decoder = JSONDecoder()
                let fetchedData = try decoder.decode(T.self, from: data)
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

    func updateUserAddress(_ address: Address, completion: @escaping (Result<Address, NetworkError>) -> Void) {
        guard let url = URL(string: "\(endPoint.userAddress.rawValue)/\(address.userId)") else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.put.rawValue
        request.setValue(HTTPHeader.Value.json, forHTTPHeaderField: HTTPHeader.Field.contentType)

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(address)
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
                let decoder = JSONDecoder()
                let fetchedData = try decoder.decode(Address.self, from: data)
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
