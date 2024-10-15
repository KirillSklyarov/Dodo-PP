//
//  StartersModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import Foundation

struct StartersModel: FoodItems {
    var id: String
    var category: CategoriesNames
    var name: String
    var imageName: String
    var ingredients: String
    var toppings: [ToppingEnum]
    var itemSize: [Size: WeightPrice]
    var isHit: Bool
    var isHeader: Bool

    init(id: String, category: CategoriesNames = .starters, name: String, imageName: String, ingredients: String, toppings: [ToppingEnum] = [], isHit: Bool = false, itemSize: [Size: WeightPrice], isHeader: Bool = false) {
        self.id = id
        self.category = category
        self.name = name
        self.imageName = imageName
        self.ingredients = ingredients
        self.toppings = toppings
        self.isHit = isHit
        self.itemSize = itemSize
        self.isHeader = isHeader
    }
}

let starters: [StartersModel] = [
    StartersModel(id: "1E2F3A4B-5C6D-7E8F-90A1-B2C3D4E5F6A7", name: "Паста с креветками", imageName: "starter1", ingredients: "Паста из печи с креветками, томатами, моцареллой, соусом альфредо и чесноком", itemSize: [.medium : WeightPrice(weight: 100, price: 200, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    StartersModel(id: "2F3A4B5C-6D7E-8F90-A1B2-C3D4E5F6A7B8", name: "Дэнвич ветчина и сыр", imageName: "starter2", ingredients: "Поджаристая чиабатта и знакомое сочетание ветчины, цыпленка, моцареллы со свежими томатами, соусом ранч и чесноком", itemSize: [.medium : WeightPrice(weight: 100, price: 200, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    StartersModel(id: "3A4B5C6D-7E8F-90A1-B2C3-D4E5F6A7B8C9", name: "Дэнвич чоризо барбекю", imageName: "starter3", ingredients: "Насыщенный вкус острых колбасок чоризо и пикантной пепперони с соусами бургер и барбекю", itemSize: [.medium : WeightPrice(weight: 100, price: 200, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    StartersModel(id: "4B5C6D7E-8F90-A1B2-C3D4-E5F6A7B8C9D0", name: "Паста Карбонара", imageName: "starter4", ingredients: "Паста из печи с беконом, сырами чеддер и пармезан, томатами, моцареллой, фирменным соусом альфредо и чесноком", itemSize: [.medium : WeightPrice(weight: 100, price: 200, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    StartersModel(id: "5C6D7E8F-90A1-B2C3-D4E5-F6A7B8C9D0E1", name: "Паста Мясная", imageName: "starter5", ingredients: "Паста из печи с митболами, соусом бургер, моцареллой, фирменным томатным соусом и чесноком", itemSize: [.medium : WeightPrice(weight: 100, price: 200, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))])
]
