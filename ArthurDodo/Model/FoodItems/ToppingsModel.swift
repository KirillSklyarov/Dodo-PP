//
//  Toppings.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 20.09.2024.
//

import Foundation

struct Topping {
    let name: String
    let imageName: String
    let price: Int
}

let toppings: [Topping] = [
    Topping(name: "cheese", imageName: "cheese", price: 75),
    Topping(name: "onion", imageName: "onion", price: 50),
    Topping(name: "halapeno", imageName: "halapeno", price: 150),
    Topping(name: "sausage", imageName: "sausage", price: 125),
    Topping(name: "tomato", imageName: "tomato", price: 80),
    Topping(name: "mushrooms", imageName: "mushrooms", price: 180)
]

