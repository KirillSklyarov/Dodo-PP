import Foundation

struct Cart {
    var items: [CartItem]
}

struct CartItem: Equatable {
    let item: Item
    var chosenSize: Size
    var chosenDough: Dough?
    var chosenToppings: [Topping]?
    let weight: Int // Вес конкретной комплектации
    var price: Int // Цена конкретной комплектации
    var count: Int = 1
    let isOneSize: Bool
}
