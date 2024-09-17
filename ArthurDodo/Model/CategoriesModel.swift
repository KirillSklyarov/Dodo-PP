//
//  Pizzas.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 17.09.2024.
//

import Foundation

struct Categories {
    let header: String
    let items: [Pizza]
}

let categories: [Categories] = [Categories(header: "Римские пиццы", items: romanPizzas),
                                Categories(header: "Пиццы", items: Pizzas),
                                Categories(header: "Комбо", items: []),
                                Categories(header: "Закуски", items: []),
                                Categories(header: "Завтраки", items: [])
]
