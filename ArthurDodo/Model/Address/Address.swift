//
//  AddressModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 12.10.2024.
//

import Foundation

struct Address: Codable {
    let userId: String
    let addressId: String
    let name: String
    let cityStreetHouse: String
    let apartment: String?
    let floor: String?
    let entrance: String?
    let entranceCode: String?
    let comments: String?
}
