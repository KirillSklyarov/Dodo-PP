import UIKit

enum OrderStatus: String, Codable {
    case new = "Новый заказ"
    case inProgress = "Приняли"
    case isDelivering = "Заказ доставляется"
    case delivered = "Заказ доставлен"
    case cancelled = "Заказ отменен"
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
