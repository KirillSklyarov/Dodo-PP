//
//  NetworkHelper.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 15.10.2024.
//

import Foundation

struct HTTPHeader {
    struct Field {
        static let contentType = "Content-Type"
    }

    struct Value {
        static let json = "application/json"
    }
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case httpError(Int)
    case noData
    case decodingError(Error)
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum endPoint: String {
    case userAddress = "http://localhost:3001/userAddress"
    case toppings = "http://localhost:3001/toppings"
    case stories = "http://localhost:3001/stories"
    case products = "http://localhost:3001/products"
    case promo = "http://localhost:3001/promo"
}
