import UIKit

struct Order {
    let itemName: String
    let imageName: String
    let size: Size
    let dough: Dough?
    let weight: Int
    let price: Int
    let isHit: Bool
    var count: Int = 1
}
