//
//  PizzaModel.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 23.09.2024.
//

import Foundation

struct Pizza: FoodItems {
    var name: String
    var ingredients: String
    var imageName: String
    var isHit: Bool
    var itemSize: [Size: WeightPrice]
    var price: Int?
    var weight: Int?

    init(name: String, ingredients: String, imageName: String, size: [Size: WeightPrice], isHit: Bool = false, weight: Int? = nil, price: Int? = nil) {
        self.name = name
        self.ingredients = ingredients
        self.imageName = imageName
        self.itemSize = size
        self.isHit = isHit
    }
}

let romanPizzas: [Pizza] = [
    Pizza(name: "Цезарь",
          ingredients: "Бекон, сыры чеддер и пармезан, моцарелла, томаты, красный лук, чеснок, фирменный соус альфредо, итальянские травы",
          imageName: "cesar",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: "110", protein: "12", fat: "14", carbohydrates: "30")),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: "200", protein: "14", fat: "16", carbohydrates: "44")),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: "300", protein: "17", fat: "22", carbohydrates: "55"))],
          isHit: true
         ),

    Pizza(name: "Ветчина & Грибы", ingredients: "Бекон, сыры чеддер и пармезан, моцарелла, томаты, красный лук, чеснок, фирменный соус альфредо, итальянские травы",
          imageName: "proshutto",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: "110", protein: "12", fat: "14", carbohydrates: "30")),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: "200", protein: "14", fat: "16", carbohydrates: "44")),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: "300", protein: "17", fat: "22", carbohydrates: "55"))]
         ),

    Pizza(name: "Морская", ingredients: "Бекон, сыры чеддер и пармезан, моцарелла, томаты, красный лук, чеснок, фирменный соус альфредо, итальянские травы",
          imageName: "seafood",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: "110", protein: "12", fat: "14", carbohydrates: "30")),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: "200", protein: "14", fat: "16", carbohydrates: "44")),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: "300", protein: "17", fat: "22", carbohydrates: "55"))]
         ),

    Pizza(name: "Пепперони фреш", ingredients: "Бекон, сыры чеддер и пармезан, моцарелла, томаты, красный лук, чеснок, фирменный соус альфредо, итальянские травы",
          imageName: "seafood",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: "110", protein: "12", fat: "14", carbohydrates: "30")),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: "200", protein: "14", fat: "16", carbohydrates: "44")),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: "300", protein: "17", fat: "22", carbohydrates: "55"))]
         )
]

let pizzas: [Pizza] = [
    Pizza(name: "Карбонара", ingredients: "Бекон, сыры чеддер и пармезан, моцарелла, томаты, красный лук, чеснок, фирменный соус альфредо, итальянские травы",
          imageName: "pizza",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: "110", protein: "12", fat: "14", carbohydrates: "30")),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: "200", protein: "14", fat: "16", carbohydrates: "44")),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: "300", protein: "17", fat: "22", carbohydrates: "55"))]
         ),

    Pizza(name: "Мясная", ingredients: "Цыпленок, ветчина, пикантная пепперони, острые колбаски чоризо, моцарелла, фирменный томатный соус",
                imageName: "pizza",
                size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: "110", protein: "12", fat: "14", carbohydrates: "30")),
                       .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: "200", protein: "14", fat: "16", carbohydrates: "44")),
                       .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: "300", protein: "17", fat: "22", carbohydrates: "55"))]
               ),

    Pizza(name: "Аррива!", ingredients: "Цыпленок, острые колбаски чоризо, соус бургер, сладкий перец, красный лук, томаты, моцарелла, соус ранч, чеснок",
          imageName: "pizza",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: "110", protein: "12", fat: "14", carbohydrates: "30")),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: "200", protein: "14", fat: "16", carbohydrates: "44")),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: "300", protein: "17", fat: "22", carbohydrates: "55"))]
         ),

    Pizza(name: "Бургер-пицца", ingredients: "Ветчина, маринованные огурчики, томаты, красный лук, чеснок, соус бургер, моцарелла, фирменный томатный соус",
          imageName: "pizza",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: "110", protein: "12", fat: "14", carbohydrates: "30")),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: "200", protein: "14", fat: "16", carbohydrates: "44")),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: "300", protein: "17", fat: "22", carbohydrates: "55"))]
         ),

    Pizza(name: "Сырный цыпленок", ingredients: "Цыпленок, сыры чеддер, моцарелла, фирменный томатный соус",
          imageName: "pizza",
          size: [.small: WeightPrice(weight: 300, price: 500, cpfc: CPFC(calories: "110", protein: "12", fat: "14", carbohydrates: "30")),
                 .medium: WeightPrice(weight: 400, price: 600, cpfc: CPFC(calories: "200", protein: "14", fat: "16", carbohydrates: "44")),
                 .large: WeightPrice(weight: 500, price: 700, cpfc: CPFC(calories: "300", protein: "17", fat: "22", carbohydrates: "55"))]
         )
]
