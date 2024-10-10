//
//  CocktailModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 07.10.2024.
//

import Foundation

struct CocktailModel: FoodItems {
    var id: String
    var category: CategoriesNames
    var name: String
    var imageName: String
    var ingredients: String
    var isHit: Bool
    var itemSize: [Size: WeightPrice]
    var isHeader: Bool

    init(id: String, category: CategoriesNames = .cocktail, name: String, imageName: String, ingredients: String, isHit: Bool = false, size: [Size: WeightPrice], isHeader: Bool = false) {
        self.id = id
        self.category = category
        self.name = name
        self.imageName = imageName
        self.ingredients = ingredients
        self.isHit = isHit
        self.itemSize = size
        self.isHeader = isHeader
    }
}

let cocktails: [CocktailModel] = [
    CocktailModel(id: "2B3C4D5E-6F7A-8B9C-0D1E-2F3A4B5C6D7E", name: "Молочный коктейль Ежевика-малина", imageName: "cock1", ingredients: "Сливочная прохлада классического молочного коктейля с добавлением лесных ягод", size: [.medium: WeightPrice(weight: 300, price: 220, cpfc: CPFC(calories: 150, protein: 3, fat: 7, carbohydrates: 18))]),
    CocktailModel(id: "4D5E6F7A-8B9C-0D1E-2F3A-4B5C6D7E8F90", name: "Молочный коктейль Пина Колада", imageName: "cock2", ingredients: "Тропическое сочетание кокоса и ананаса в нежном милкшейке", size: [.medium: WeightPrice(weight: 300, price: 220, cpfc: CPFC(calories: 150, protein: 3, fat: 7, carbohydrates: 18))]),
    CocktailModel(id: "7E57D004-2B97-0E7A-B45F-5387367791CD", name: "Молочный коктейль с печеньем Орео", imageName: "cock3", ingredients: "Как вкуснее есть печенье? Его лучше пить! Попробуйте молочный коктейль с мороженым и дробленым печеньем «Орео»", size: [.medium: WeightPrice(weight: 300, price: 220, cpfc: CPFC(calories: 150, protein: 3, fat: 7, carbohydrates: 18))]),
    CocktailModel(id: "16FD2706-8DEE-46EA-92FF-5C0A9E3A7A19", name: "Классический молочный коктейль", imageName: "cock4", ingredients: "В мире так много коктейлей, но классика — вечна. Попробуйте наш молочный напиток с мороженым", size: [.medium: WeightPrice(weight: 300, price: 220, cpfc: CPFC(calories: 150, protein: 3, fat: 7, carbohydrates: 18))]),
    CocktailModel(id: "22A4B0F7-2D8F-4C21-9F1F-7BB1F1C6C4E5", name: "Клубничный молочный коктейль", imageName: "cock5", ingredients: "Не важно, какое время года на улице, этот коктейль с клубничным концентратом вернет вас в лето с одного глотка", size: [.medium: WeightPrice(weight: 300, price: 220, cpfc: CPFC(calories: 150, protein: 3, fat: 7, carbohydrates: 18))]),
    ]
