import Foundation

enum CPFCData: String, Codable, CaseIterable {
    case weight = "Вес"
    case calories = "Пищевая ценность"
    case proteins = "Белки"
    case fats = "Жиры"
    case carbohydrates = "Углеводы"
}
