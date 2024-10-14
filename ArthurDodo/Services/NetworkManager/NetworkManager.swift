//
//  NetworkManager.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 14.10.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case httpError(Int)
    case noData
    case decodingError(Error)
}

enum endPoint: String {
    case userAddress = "http://localhost:3001/userAddress"
}

final class NetworkManager {

    static let shared = NetworkManager()
    private init() {}

    var addresses: [AddressModel]?

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
}
