//
//  AddressModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 12.10.2024.
//

import Foundation

struct AddressModel: Encodable, Decodable {
    let name: String
    let cityStreetHouse: String
    let apartment: Int?
    let floor: Int?
    let entrance: Int?
    let entranceCode: String?
    let comments: String?
}

let myAddresses = [
    AddressModel(name: "Дом", cityStreetHouse: "Москва, Первое шоссе, 45", apartment: 90, floor: 5, entrance: 1, entranceCode: "f1234", comments: "Не звонить"),
    AddressModel(name: "Работа", cityStreetHouse: "Москва, Второе шоссе, 4", apartment: 4, floor: 1, entrance: 1, entranceCode: "к2345", comments: nil)
]
