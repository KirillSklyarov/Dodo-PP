//
//  BreakfastModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import Foundation

struct BreakfastModel: FoodItems {
    var id: UUID
    var category: CategoriesNames
    var name: String
    var imageName: String
    var ingredients: String
    var isHit: Bool
    var itemSize: [Size: WeightPrice]
    var isHeader: Bool

    init(id: UUID = UUID(), category: CategoriesNames = .breakfast, name: String, imageName: String, ingredients: String, isHit: Bool = false, size: [Size: WeightPrice], isHeader: Bool = false) {
        self.name = name
        self.imageName = imageName
        self.ingredients = ingredients
        self.isHit = isHit
        self.itemSize = size
        self.id = id
        self.isHeader = isHeader
        self.category = category
    }
}

let breakfast: [BreakfastModel] = [
    BreakfastModel(name: "Омлет с беконом", imageName: "breakf1", ingredients: "Классическое сочетание горячего омлета с поджаристой корочкой и бекона с добавлением моцареллы и томатов на завтрак", size: [.medium: WeightPrice(weight: 100, price: 100, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    BreakfastModel(name: "Омлет с ветчиной и грибами", imageName: "breakf2", ingredients: "Горячий сытный омлет с поджаристой корочкой, ветчина, шампиньоны и моцарелла", size: [.medium: WeightPrice(weight: 150, price: 150, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    BreakfastModel(name: "Омлет с пепперони", imageName: "breakf3", ingredients: "Сытный и сбалансированный завтрак — омлет с поджаристой корочкой, пикантная пепперони, томаты и моцарелла", size: [.medium: WeightPrice(weight: 200, price: 200, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    BreakfastModel(name: "Омлет сырный", imageName: "breakf4", ingredients: "Горячий завтрак из омлета с поджаристой корочкой, моцарелла, кубики брынзы, сыры чеддер и пармезан", size: [.medium: WeightPrice(weight: 250, price: 250, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),

    BreakfastModel(name: "Додстер с ветчиной", imageName: "breakf5", ingredients: "Горячий завтрак с ветчиной, томатами, моцареллой, соусом ранч в тонкой пшеничной лепешке", size: [.medium: WeightPrice(weight: 300, price: 300, cpfc: CPFC(calories: 10, protein: 10, fat: 10, carbohydrates: 10))]),
]
