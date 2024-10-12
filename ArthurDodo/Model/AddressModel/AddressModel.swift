//
//  AddressModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 12.10.2024.
//

import Foundation

struct AddressModel {
    let name: String
    let city: String
    let street: String
    let house: String
    let apartment: Int
}

let myAddresses = [
    AddressModel(name: "Дом", city: "Москва", street: "Первое шоссе", house: "45", apartment: 50)
]
