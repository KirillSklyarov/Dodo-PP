//
//  SpecialOfferModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 09.10.2024.
//

import Foundation

struct SpecialOffer {
    let item: Item

    static func configRandomOffer(_ allItems: [Item], _ countOfElements: Int) -> [Item] {
        var result: [Item] = []
        let shuffledItems = allItems.shuffled()
        result += shuffledItems.prefix(countOfElements)
        return result
    }
}
