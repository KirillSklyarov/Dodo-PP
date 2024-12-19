import UIKit

enum OrderStatus: String, Codable {
    case new = "Новый заказ"
    case inProgress = "Приняли"
    case isDelivering = "Заказ доставляется"
    case delivered = "Заказ доставлен"
    case cancelled = "Заказ отменен"
}

enum Dough: Int, Codable {
    case basic = 0
    case thin

    var displayName: String {
        switch self {
        case .basic: return "Традиционное тесто"
        case .thin: return "Тонкое тесто"
        }
    }
}

enum Size: Int, Codable {
    case small = 0
    case medium
    case large
    case oneSize

    var displayName: String {
        switch self {
        case .small: return "25 см"
        case .medium: return "30 см"
        case .large: return "35 см"
        case .oneSize: return ""
        }
    }
}


struct Order: Codable {
    var position: [OrderPosition]
    var deliveryAddress: String?
    var deliveryTime: String?
    var status: OrderStatus = .new
}

struct OrderPosition: Codable {
    let itemName: String
    let size: Size
    let dough: Dough?
    let weight: Int
    let price: Int
    var count: Int
}
