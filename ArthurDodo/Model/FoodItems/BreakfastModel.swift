//
//  BreakfastModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import Foundation

struct BreakfastModel: FoodItems {
    var id: String
    var category: CategoriesNames
    var name: String
    var imageName: String
    var ingredients: String
    var toppings: [ToppingEnum]
    var isHit: Bool
    var itemSize: [Size: WeightPrice]
    var isHeader: Bool

    init(id: String, category: CategoriesNames = .breakfast, name: String, imageName: String, ingredients: String, toppings: [ToppingEnum] = [], isHit: Bool = false, size: [Size: WeightPrice], isHeader: Bool = false) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.ingredients = ingredients
        self.toppings = toppings
        self.isHit = isHit
        self.itemSize = size
        self.isHeader = isHeader
        self.category = category
    }
}

let breakfast: [BreakfastModel] = [
    BreakfastModel(id: "E4EAAAF0-9C37-4EB1-9C93-9E2B0BBF0C6D", name: "Омлет с беконом", imageName: "breakf1", ingredients: "Классическое сочетание горячего омлета с поджаристой корочкой и бекона с добавлением моцареллы и томатов на завтрак", size: [.medium: WeightPrice(weight: 100, price: 100, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    BreakfastModel(id: "8A8F3A6B-F99F-4A3E-828A-0C9A3B7D2F1E", name: "Омлет с ветчиной и грибами", imageName: "breakf2", ingredients: "Горячий сытный омлет с поджаристой корочкой, ветчина, шампиньоны и моцарелла", size: [.medium: WeightPrice(weight: 150, price: 150, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    BreakfastModel(id: "5B6F9C4D-7E2A-4B1C-9D8E-6F7A8B9C0D1E", name: "Омлет с пепперони", imageName: "breakf3", ingredients: "Сытный и сбалансированный завтрак — омлет с поджаристой корочкой, пикантная пепперони, томаты и моцарелла", size: [.medium: WeightPrice(weight: 200, price: 200, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    BreakfastModel(id: "3C4D5E6F-7A8B-9C0D-1E2F-3A4B5C6D7E8F", name: "Омлет сырный", imageName: "breakf4", ingredients: "Горячий завтрак из омлета с поджаристой корочкой, моцарелла, кубики брынзы, сыры чеддер и пармезан", size: [.medium: WeightPrice(weight: 250, price: 250, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    BreakfastModel(id: "1A2B3C4D-5E6F-7A8B-9C0D-1E2F3A4B5C6D", name: "Додстер с ветчиной", imageName: "breakf5", ingredients: "Горячий завтрак с ветчиной, томатами, моцареллой, соусом ранч в тонкой пшеничной лепешке", size: [.medium: WeightPrice(weight: 300, price: 300, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),
]
