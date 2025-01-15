import Foundation

struct Topping: Codable, Equatable {
    let name: ToppingEnum
    let imageName: String
    let price: Int
}

enum ToppingEnum: String, Codable {
    case cheese = "cheese"
    case onion = "onion"
    case jalapeno = "jalapeno"
    case sausage = "sausage"
    case tomato = "tomato"
    case mushrooms = "mushrooms"
}
