//
//  Pizzas.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 17.09.2024.
//

import Foundation

protocol FoodItems {
    var name: String { get set }
    var imageName: String { get set }
    var ingredients: String { get set }
    var isHit: Bool { get set }
    var itemSize: [Size: WeightPrice] { get set }
}

struct Categories {
    let header: String
    let items: [FoodItems]
}

let categories: [Categories] = [ Categories(header: "Завтрак", items: breakfast),
                                 Categories(header: "Римские пиццы", items: romanPizzas),
                                 Categories(header: "Пиццы", items: pizzas),
                                 Categories(header: "Комбо", items: combos),
                                 Categories(header: "Закуски", items: starters),
]
