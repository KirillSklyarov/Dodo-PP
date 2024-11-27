import Foundation

enum Size: Int, Codable {
    case small = 0
    case medium
    case large
    case oneSize

    var displayName: String {
        switch self {
        case .small: return "Маленькая 25 см"
        case .medium: return "Средняя 30 см"
        case .large: return "Большая 35 см"
        case .oneSize: return ""
        }
    }
}
