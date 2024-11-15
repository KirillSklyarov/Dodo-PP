import Foundation

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
