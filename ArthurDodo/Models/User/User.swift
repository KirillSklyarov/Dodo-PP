import Foundation

struct User: Codable {
    let userId: String
    let firstName: String
    let phoneNumber: String
    let email: String
    let dateOfBirth: String
    let agreeOfSending: Bool
    let dodoCoins: Int
    let orders: Int
    let address: [Address]
}
