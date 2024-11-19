//
//  Pizza2.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 18.10.2024.
//

import Foundation

struct Item: Codable {
    var id: String
    var category: CategoryName
    var name: String
    var ingredients: String
    var toppings: [ToppingEnum]
    var imageName: String
    var isHit: Bool
    var itemSize: ItemSize
    var price: Int?
    var weight: Int?
    var isHeader: Bool

    init(id: String, category: CategoryName = .pizzas, name: String, ingredients: String, toppings: [ToppingEnum] = [], imageName: String, itemSize: ItemSize, isHit: Bool = false, weight: Int? = nil, price: Int? = nil, isHeader: Bool = false) {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.toppings = toppings
        self.imageName = imageName
        self.itemSize = itemSize
        self.isHit = isHit
        self.isHeader = isHeader
        self.category = category
    }
}
