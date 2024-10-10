//
//  Pizzas.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 17.09.2024.
//

import Foundation

protocol FoodItems {
    var id: String { get }
    var category: CategoriesNames { get set }
    var name: String { get set }
    var imageName: String { get set }
    var ingredients: String { get set }
    var isHit: Bool { get set }
    var itemSize: [Size: WeightPrice] { get set }
    var isHeader: Bool { get set }

}

enum CategoriesNames: String {
    case breakfast = "Завтрак"
    case combos = "Комбо"
    case starters = "Закуски"
    case pizzas = "Пиццы"
    case cocktail = "Коктейли"
}

struct Categories {
    let header: CategoriesNames
    let items: [FoodItems]
}

let categories: [Categories] = [ Categories(header: .breakfast, items: breakfast),
                                 Categories(header: .combos, items: combos),
                                 Categories(header: .starters, items: starters),
                                 Categories(header: .pizzas, items: pizzas),
                                 Categories(header: .cocktail, items: cocktails)
]

private func convertToAllItems() -> [FoodItems] {
    var result: [FoodItems] = []
    for category in categories {
        var temp: [FoodItems] = []
        temp = category.items
        temp[0].isHeader = true
        result += temp
    }
    return result
}

let allItems = convertToAllItems()
