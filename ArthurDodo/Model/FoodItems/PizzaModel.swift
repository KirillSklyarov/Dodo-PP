//
//  PizzaModel.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 23.09.2024.
//

import Foundation

struct Pizza: FoodItems {
    var id: String
    var category: CategoriesNames
    var name: String
    var ingredients: String
    var toppings: [ToppingEnum]
    var imageName: String
    var isHit: Bool
    var itemSize: [Size: WeightPrice]
    var price: Int?
    var weight: Int?
    var isHeader: Bool

    init(id: String, category: CategoriesNames = .pizzas, name: String, ingredients: String, toppings: [ToppingEnum] = [], imageName: String, size: [Size: WeightPrice], isHit: Bool = false, weight: Int? = nil, price: Int? = nil, isHeader: Bool = false) {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.toppings = toppings
        self.imageName = imageName
        self.itemSize = size
        self.isHit = isHit
        self.isHeader = isHeader
        self.category = category
    }
}

let pizzas: [Pizza] = [
    Pizza(id: "6D7E8F90-A1B2-C3D4-E5F6-A7B8C9D0E1F2", name: "Карбонара", ingredients: "Бекон, сыры чеддер и пармезан, моцарелла, томаты, красный лук, чеснок, фирменный соус альфредо, итальянские травы",
          toppings: [.cheese, .jalapeno],
          imageName: "pizza",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: 110, protein: 12, fat: 14, carbohydrates: 30)),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: 200, protein: 14, fat: 16, carbohydrates: 44)),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: 300, protein: 17, fat: 22, carbohydrates: 55))]
         ),

    Pizza(id: "7E8F90A1-B2C3-D4E5-F6A7-B8C9D0E1F2A3", name: "Мясная", ingredients: "Цыпленок, ветчина, пикантная пепперони, острые колбаски чоризо, моцарелла, фирменный томатный соус",
                imageName: "pizza",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: 110, protein: 12, fat: 14, carbohydrates: 30)),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: 200, protein: 14, fat: 16, carbohydrates: 44)),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: 300, protein: 17, fat: 22, carbohydrates: 55))]
               ),

    Pizza(id: "8F90A1B2-C3D4-E5F6-A7B8-C9D0E1F2A3B4", name: "Аррива!", ingredients: "Цыпленок, острые колбаски чоризо, соус бургер, сладкий перец, красный лук, томаты, моцарелла, соус ранч, чеснок",
          imageName: "pizza",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: 110, protein: 12, fat: 14, carbohydrates: 30)),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: 200, protein: 14, fat: 16, carbohydrates: 44)),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: 300, protein: 17, fat: 22, carbohydrates: 55))]
         ),

    Pizza(id: "9F90A1B2-C3D4-E5F6-A7B8-C9D0E1F2A3B5", name: "Бургер-пицца", ingredients: "Ветчина, маринованные огурчики, томаты, красный лук, чеснок, соус бургер, моцарелла, фирменный томатный соус",
          imageName: "pizza",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: 110, protein: 12, fat: 14, carbohydrates: 30)),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: 200, protein: 14, fat: 16, carbohydrates: 44)),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: 300, protein: 17, fat: 22, carbohydrates: 55))]
         ),

    Pizza(id: "F47AC10B-58CC-4372-A567-0E02B2C3D479", name: "Сырный цыпленок", ingredients: "Цыпленок, сыры чеддер, моцарелла, фирменный томатный соус",
          imageName: "pizza",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: 110, protein: 12, fat: 14, carbohydrates: 30)),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: 200, protein: 14, fat: 16, carbohydrates: 44)),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: 300, protein: 17, fat: 22, carbohydrates: 55))]
         ),

    Pizza(id: "9B2C4D1E-6F7A-8B9C-0D1E-2F3A4B5C6D7E", name: "Цезарь",
          ingredients: "Бекон, сыры чеддер и пармезан, моцарелла, томаты, красный лук, чеснок, фирменный соус альфредо, итальянские травы",
          imageName: "cesar",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: 110, protein: 12, fat: 14, carbohydrates: 30)),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: 200, protein: 14, fat: 16, carbohydrates: 44)),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: 300, protein: 17, fat: 22, carbohydrates: 55))],
          isHit: true
         ),

    Pizza(id: "A3B4C5D6-E7F8-9012-3456-789ABCDEF012", name: "Ветчина & Грибы", ingredients: "Бекон, сыры чеддер и пармезан, моцарелла, томаты, красный лук, чеснок, фирменный соус альфредо, итальянские травы",
          imageName: "proshutto",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: 110, protein: 12, fat: 14, carbohydrates: 30)),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: 200, protein: 14, fat: 16, carbohydrates: 44)),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: 300, protein: 17, fat: 22, carbohydrates: 55))]),

    Pizza(id: "C1D2E3F4-A5B6-7890-C1D2-E3F4A5B6C7D8", name: "Морская", ingredients: "Бекон, сыры чеддер и пармезан, моцарелла, томаты, красный лук, чеснок, фирменный соус альфредо, итальянские травы",
          imageName: "seafood",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: 110, protein: 12, fat: 14, carbohydrates: 30)),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: 200, protein: 14, fat: 16, carbohydrates: 44)),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: 300, protein: 17, fat: 22, carbohydrates: 55))]),


    Pizza(id: "D4E5F6A7-B8C9-0123-4567-89ABCDEF1234", name: "Пепперони фреш", ingredients: "Бекон, сыры чеддер и пармезан, моцарелла, томаты, красный лук, чеснок, фирменный соус альфредо, итальянские травы", imageName: "seafood",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: 110, protein: 12, fat: 14, carbohydrates: 30)),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: 200, protein: 14, fat: 16, carbohydrates: 44)),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: 300, protein: 17, fat: 22, carbohydrates: 55))]),

    Pizza(id: "E5F6A7B8-C9D0-1234-5678-9ABCDEF12345", name: "Креветки со сладким чили", ingredients: "Креветки , ананасы , соус сладкий чили, сладкий перец , моцарелла, фирменный соус альфредо",
          imageName: "chilli",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: 110, protein: 12, fat: 14, carbohydrates: 30)),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: 200, protein: 14, fat: 16, carbohydrates: 44)),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: 300, protein: 17, fat: 22, carbohydrates: 55))])
]
