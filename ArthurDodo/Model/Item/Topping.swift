//
//  Toppings.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 20.09.2024.
//

import Foundation

struct Topping: Codable {
    let name: ToppingEnum
    let imageName: String
    let price: Int
}
