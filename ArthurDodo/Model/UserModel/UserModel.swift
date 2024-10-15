//
//  UserModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 11.10.2024.
//

import Foundation

struct UserModel {
    let name: String
    let phone: String
    let email: String
    let dateOfBirth: String
    let agreeOfSending: Bool
}

let testUser = UserModel(name: "Кирилл", phone: "+7999999999", email: "aaa@mail.ru", dateOfBirth: "01.01.01", agreeOfSending: true)
