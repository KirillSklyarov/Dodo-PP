import Foundation

// Здесь мы указываем хэдеры
struct HTTPHeader {
    struct Field {
        static let contentType = "Content-Type"
    }

    struct Value {
        static let json = "application/json"
    }
}

// Обработка ошибок
enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case httpError(Int)
    case noData
    case decodingError(Error)
}

// Методы
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// Точки доступа
enum BaseURL: String {
    case ngrok = "https://871d-213-183-59-146.ngrok-free.app"
    case mockoon = "http://localhost:3001"
}

enum endPoint: String {
    private static let baseURL: BaseURL = .mockoon

    case userAddress = "/userAddress"
    case toppings = "/toppings"
    case stories = "/stories"
    case products = "/products"
    case promo = "/promo"
    case personal = "/personal"
    case error = "/error"

    // Формирует ссылку
    var url: URL? {
        var components = URLComponents(string: endPoint.baseURL.rawValue)
        components?.path = self.rawValue
        return components?.url
    }

    // Добавляет в предыдущую ссылку свойство userID.
    func getURL(with userID: String) -> URL? {
        let url = self.url?.appendingPathComponent(userID)
        return url
    }
}
