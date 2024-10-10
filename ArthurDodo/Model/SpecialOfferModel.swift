//
//  SpecialOfferModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 09.10.2024.
//

import Foundation


struct SpecialOfferModel {
    let item: FoodItems
}

func configRandomOffer(countOfElements: Int = 4) -> [FoodItems] {
    var result: [FoodItems] = []
    let shuffledItems = allItems.shuffled()
    result += shuffledItems.prefix(countOfElements)
    return result
}

let specialOfferArray = configRandomOffer()
