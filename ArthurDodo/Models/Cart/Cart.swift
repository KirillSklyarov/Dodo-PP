import Foundation

struct Cart {
    var items: [CartItem]
}

struct CartItem: Equatable {
    let id: String
    let name: String
    let imageName: String
    let size: Size
    let dough: Dough?
    let weight: Int
    let price: Int
    let isHit: Bool
    var count: Int = 1
    let isOneSize: Bool
}
