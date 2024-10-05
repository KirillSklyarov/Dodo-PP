//
//  ComboModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import Foundation

struct ComboModel: FoodItems {
    var name: String
    var imageName: String
    var ingredients: String
    var isHit: Bool
    let items: [Pizza?]?
    var itemSize: [Size: WeightPrice]

    init(name: String, imageName: String, ingredients: String, isHit: Bool = false, items: [Pizza?]?, size: [Size: WeightPrice]) {
        self.name = name
        self.imageName = imageName
        self.ingredients = ingredients
        self.isHit = isHit
        self.items = items
        self.itemSize = size
    }
}

let combos = [
    ComboModel(name: "Детское комбо", imageName: "Combo1", ingredients: "Маленькая пицца на обед и милая игрушка для хорошего настроения. Пусть ребенок покажет Додозаврику как правильно кушать!", items: nil, size: [.medium: WeightPrice(weight: 100, price: 100, cpfc: CPFC(calories: "10", protein: "10", fat: "10", carbohydrates: "10"))]),

    ComboModel(name: "Чикен бокс", imageName: "Combo2", ingredients: "Картошка без курицы, как курица без картошки — лучше вместе", items: nil, size: [.medium: WeightPrice(weight: 150, price: 150, cpfc: CPFC(calories: "10", protein: "10", fat: "10", carbohydrates: "10"))]),

    ComboModel(name: "Комбо Завтрак на двоих", imageName: "Combo3", ingredients: "Горячий завтрак для двоих. 2 любые закуски и 2 напитка на выбор", items: nil, size: [.medium: WeightPrice(weight: 200, price: 200, cpfc: CPFC(calories: "10", protein: "10", fat: "10", carbohydrates: "10"))]),

    ComboModel(name: "Четыре в одном", imageName: "Combo4", ingredients: "Если хочется всего понемногу. Маленькая пицца, закуска, напиток и соус. Цена комбо зависит от выбранных продуктов и может быть увеличена", items: nil, size: [.medium: WeightPrice(weight: 250, price: 250, cpfc: CPFC(calories: "10", protein: "10", fat: "10", carbohydrates: "10"))]),

    ComboModel(name: "3 пиццы 25 см", imageName: "Combo5", ingredients: "Настоящая дегустация. Три маленькие пиццы по суперцене. Цена комбо зависит от выбранных пицц и может быть увеличена", items: nil, size: [.medium: WeightPrice(weight: 300, price: 300, cpfc: CPFC(calories: "10", protein: "10", fat: "10", carbohydrates: "10"))]),

    ComboModel(name: "2 пиццы", imageName: "Combo6", ingredients: "Парочка что надо. 2 средние пиццы. Цена комбо зависит от выбранных пицц и может быть увеличена", items: nil, size: [.medium: WeightPrice(weight: 350, price: 350, cpfc: CPFC(calories: "10", protein: "10", fat: "10", carbohydrates: "10"))]),
]
