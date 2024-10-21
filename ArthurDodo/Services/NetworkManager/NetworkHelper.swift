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
    private static let baseURL = "https://a81a-213-183-59-146.ngrok-free.app"

    case userAddress = "/userAddress"
    case toppings = "/toppings"
    case stories = "/stories"
    case products = "/products"
    case promo = "/promo"

    var url: String {
        return endPoint.baseURL + self.rawValue
    }
}
