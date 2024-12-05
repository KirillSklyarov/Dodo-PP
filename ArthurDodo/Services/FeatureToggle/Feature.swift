import Foundation

struct Feature: Codable {
    let name: String
    var isEnabled: Bool
}

enum FeatureType: String {
    case profile = "X-101: Profile"
    case cart = "X-109: Cart"
}
