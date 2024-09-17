//
//  Constants.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 18.09.2024.
//

import UIKit

enum Size: String {
    case small = "Маленькая 25 см"
    case medium = "Средняя 30 см"
    case large = "Большая 35 см"
}

enum Dough: String {
    case basic = "Традиционное тесто"
    case thin = "Тонкое тесто"
}

struct WeightPrice {
    let weight: Int
    let price: Int
    let cpfc: CPFC
}

struct CPFC {
    let calories: String
    let protein: String
    let fat: String
    let carbohydrates: String
}

enum CPFCData: String, CaseIterable {
    case weight = "Вес"
    case calories = "Пищевая ценность"
    case proteins = "Белки"
    case fats = "Жиры"
    case carbohydrates = "Углеводы"
}

struct AppColors {
    let peach = UIColor(hex: "f7d794")
    let blue = UIColor(hex: "778beb")
    let geranium = UIColor(hex: "cf6a87")
    let orange = UIColor(hex: "e15f41")
    let majesty = UIColor(hex: "786fa6")
    let summer = UIColor(hex: "f5cd79")
    let sky = UIColor(hex: "63cdda")
    let pencil = UIColor(hex: "596275")
    let wild = UIColor(hex: "574b90")
    let rock = UIColor(hex: "303952")

    func getRandomColor() -> UIColor {
        let colors = [peach, blue, geranium, orange, majesty, summer, sky, pencil, wild, rock]
        return colors.randomElement() ?? UIColor.black
    }
}
