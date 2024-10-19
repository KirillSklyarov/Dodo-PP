//
//  Size.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 19.10.2024.
//

import Foundation

enum Size: Codable {
    case small
    case medium
    case large

    var displayName: String {
        switch self {
        case .small: return "Маленькая 25 см"
        case .medium: return "Средняя 30 см"
        case .large: return "Большая 35 см"
        }
    }
}
