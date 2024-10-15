//
//  Toppings.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 20.09.2024.
//

import Foundation

enum ToppingEnum: String, Codable {
    case cheese = "cheese"
    case onion = "onion"
    case jalapeno = "jalapeno"
    case sausage = "sausage"
    case tomato = "tomato"
    case mushrooms = "mushrooms"
}

struct Topping: Codable {
    let name: ToppingEnum
    let imageName: String
    let price: Int
}
