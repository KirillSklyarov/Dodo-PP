//
//  SpecialOfferProfileModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 10.10.2024.
//

import Foundation

struct SpecialOfferProfileModel {
    let name: String
    let details: String
    let date: String
    let imageName: String
}

let specialOffersProfile = [
    SpecialOfferProfileModel(name: "В пиццерии и на самовывоз", details: "Скидка 30% при заказе от 649 руб.", date: "до 13 октября", imageName: "spOffer1"),
    SpecialOfferProfileModel(name: "На любой тип заказа", details: "300 флеш додокоинов на заказ от 1649 руб.", date: "до 13 октября", imageName: "spOffer2")
]
