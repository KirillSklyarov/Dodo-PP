//
//  StartersModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import Foundation

struct StartersModel: FoodItems {
    var id: UUID
    var category: CategoriesNames
    var name: String
    var imageName: String
    var ingredients: String
    var itemSize: [Size: WeightPrice]
    var isHit: Bool
    var isHeader: Bool

    init(id: UUID = UUID(), category: CategoriesNames = .starters, name: String, imageName: String, ingredients: String, isHit: Bool = false, itemSize: [Size: WeightPrice], isHeader: Bool = false) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.ingredients = ingredients
        self.isHit = isHit
        self.itemSize = itemSize
        self.isHeader = isHeader
        self.category = category
    }
}

let starters: [StartersModel] = [
    StartersModel(name: "Паста с креветками", imageName: "starter1", ingredients: "Паста из печи с креветками, томатами, моцареллой, соусом альфредо и чесноком", itemSize: [.medium : WeightPrice(weight: 100, price: 200, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    StartersModel(name: "Дэнвич ветчина и сыр", imageName: "starter2", ingredients: "Поджаристая чиабатта и знакомое сочетание ветчины, цыпленка, моцареллы со свежими томатами, соусом ранч и чесноком", itemSize: [.medium : WeightPrice(weight: 100, price: 200, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    StartersModel(name: "Дэнвич чоризо барбекю", imageName: "starter3", ingredients: "Насыщенный вкус острых колбасок чоризо и пикантной пепперони с соусами бургер и барбекю", itemSize: [.medium : WeightPrice(weight: 100, price: 200, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    StartersModel(name: "Паста Карбонара", imageName: "starter4", ingredients: "Паста из печи с беконом, сырами чеддер и пармезан, томатами, моцареллой, фирменным соусом альфредо и чесноком", itemSize: [.medium : WeightPrice(weight: 100, price: 200, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    StartersModel(name: "Паста Мясная", imageName: "starter5", ingredients: "Паста из печи с митболами, соусом бургер, моцареллой, фирменным томатным соусом и чесноком", itemSize: [.medium : WeightPrice(weight: 100, price: 200, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))])
]
