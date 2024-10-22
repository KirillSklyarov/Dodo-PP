//
//  OrderModel.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 27.09.2024.
//

import Foundation

struct Order {
    let pizzaName: String
    let imageName: String
    let size: Size
    let dough: Dough
    let price: Int
    let isHit: Bool
    var count: Int = 1
}
