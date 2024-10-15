//
//  ComboModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import Foundation

struct ComboModel: FoodItems {
    var id: String
    var category: CategoriesNames
    var name: String
    var imageName: String
    var ingredients: String
    var toppings: [ToppingEnum]
    var isHit: Bool
    let items: [Pizza?]?
    var itemSize: [Size: WeightPrice]
    var isHeader: Bool

    init(id: String, category: CategoriesNames = .combos, name: String, imageName: String, ingredients: String, toppings: [ToppingEnum] = [], isHit: Bool = false, items: [Pizza?]?, size: [Size: WeightPrice], isHeader: Bool = false) {
        self.id = id
        self.category = category
        self.name = name
        self.imageName = imageName
        self.ingredients = ingredients
        self.toppings = toppings
        self.isHit = isHit
        self.items = items
        self.itemSize = size
        self.isHeader = isHeader
    }
}

let combos = [
    ComboModel(id: "D6F6DA1A-2D4F-4E4A-9233-6F4B8B2F3F2A", name: "Детское комбо", imageName: "combo1", ingredients: "Маленькая пицца на обед и милая игрушка для хорошего настроения. Пусть ребенок покажет Додозаврику как правильно кушать!", items: nil, size: [.medium: WeightPrice(weight: 100, price: 100, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    ComboModel( id: "8B7C4E3D-5F6A-4D7E-8C9B-0E1F2A3B4C5D", name: "Чикен бокс", imageName: "combo2", ingredients: "Картошка без курицы, как курица без картошки — лучше вместе", items: nil, size: [.medium: WeightPrice(weight: 150, price: 150, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    ComboModel(id: "ABCD1234-5678-90AB-CDEF-1234567890AB", name: "Комбо Завтрак на двоих", imageName: "combo3", ingredients: "Горячий завтрак для двоих. 2 любые закуски и 2 напитка на выбор", items: nil, size: [.medium: WeightPrice(weight: 200, price: 200, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    ComboModel(id: "FEDCBA98-7654-3210-DCBA-9876543210FE", name: "Четыре в одном", imageName: "combo4", ingredients: "Если хочется всего понемногу. Маленькая пицца, закуска, напиток и соус. Цена комбо зависит от выбранных продуктов и может быть увеличена", items: nil, size: [.medium: WeightPrice(weight: 250, price: 250, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    ComboModel(id: "9C0D1E2F-3A4B-5C6D-7E8F-90A1B2C3D4E5", name: "3 пиццы 25 см", imageName: "combo5", ingredients: "Настоящая дегустация. Три маленькие пиццы по суперцене. Цена комбо зависит от выбранных пицц и может быть увеличена", items: nil, size: [.medium: WeightPrice(weight: 300, price: 300, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    ComboModel(id: "0D1E2F3A-4B5C-6D7E-8F90-A1B2C3D4E5F6", name: "2 пиццы", imageName: "combo6", ingredients: "Парочка что надо. 2 средние пиццы. Цена комбо зависит от выбранных пицц и может быть увеличена", items: nil, size: [.medium: WeightPrice(weight: 350, price: 350, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),
]
