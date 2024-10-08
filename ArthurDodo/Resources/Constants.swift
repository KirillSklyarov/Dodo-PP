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
    let calories: Float
    let protein: Float
    let fat: Float
    let carbohydrates: Float
}

enum CPFCData: String, CaseIterable {
    case weight = "Вес"
    case calories = "Пищевая ценность"
    case proteins = "Белки"
    case fats = "Жиры"
    case carbohydrates = "Углеводы"
}

struct AppConstants {
    static let sizeCases = ["25 cм", "30 см", "35 см"]
    static let doughCases = ["Обычное", "Тонкое"]
    static let appBuild = "1"
}

struct AppFonts {
    static let basicFont = UIFont.systemFont(ofSize: 30)

    static let regular12 = UIFont(name: "SFProRounded-Regular", size: 12) ?? basicFont
    static let regular14 = UIFont(name: "SFProRounded-Regular", size: 14) ?? basicFont
    static let regular16 = UIFont(name: "SFProRounded-Regular", size: 16) ?? basicFont

    static let semibold16 = UIFont(name: "SFProRounded-Semibold", size: 16) ?? basicFont

    static let medium16 = UIFont(name: "SFProRounded-Medium", size: 16) ?? basicFont

    static let bold14 = UIFont(name: "SFProRounded-Bold", size: 14) ?? basicFont
    static let bold16 = UIFont(name: "SFProRounded-Bold", size: 16) ?? basicFont
    static let bold18 = UIFont(name: "SFProRounded-Bold", size: 16) ?? basicFont
    static let bold20 = UIFont(name: "SFProRounded-Bold", size: 20) ?? basicFont
}

struct AppColors {
    static let grayFont = UIColor.darkGray.withAlphaComponent(0.4)
    static let backgroundGray = UIColor(hex: "222222")
    static let backgroundBlack = UIColor.black
    static let buttonGray = UIColor(hex: "#363636")

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
