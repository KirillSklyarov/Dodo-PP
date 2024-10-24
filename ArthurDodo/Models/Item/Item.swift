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
    var isHeader: Bool

    init(id: String, category: CategoryName = .pizza, name: String, ingredients: String, toppings: [ToppingEnum] = [], imageName: String, itemSize: ItemSize, isHit: Bool = false, isHeader: Bool = false) {
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

    func hasOneSize() -> Bool {
        itemSize.oneSize != nil
    }

    func getCorrectPrice(size: Size) -> Int {
        let price =
            switch size {
            case .oneSize: itemSize.oneSize?.price
            case .small: itemSize.small?.price
            case .medium: itemSize.medium?.price
            case .large: itemSize.large?.price
            }
        return price ?? 0
    }
}
