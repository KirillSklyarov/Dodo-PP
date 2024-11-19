//
//  ItemSize.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 19.10.2024.
//

import Foundation

struct ItemSize: Codable {
    let small: WeightPrice?
    let medium: WeightPrice?
    let large: WeightPrice?

    func getWeightAndPriceViaIndex(_ index: Int) -> WeightPrice? {
        switch index {
        case 0: return small
        case 1: return medium
        case 2: return large
        default: return nil
        }
    }

    func countOfSizes() -> Int {
        var count = 0
        if small != nil { count += 1 }
        if medium != nil { count += 1 }
        if large != nil { count += 1 }
        return count
    }
}

