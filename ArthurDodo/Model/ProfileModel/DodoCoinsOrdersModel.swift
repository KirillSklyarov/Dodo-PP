//
//  CoinsOrdersModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 10.10.2024.
//

import Foundation

struct DodoCoinsOrdersModel {
    let dodoCoins: Int
    let orders: Int
    let address: [String]
}

let testCoinsOrdersModel = DodoCoinsOrdersModel(dodoCoins: 1000, orders: 2, address: ["Moscow, Red Square, 1"])
