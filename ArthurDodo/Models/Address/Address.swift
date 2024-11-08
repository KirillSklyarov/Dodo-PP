import Foundation

struct Address: Codable {
    let userId: String
    let addressId: String
    var isMain: Bool
    let name: String
    let cityStreetHouse: String
    let apartment: String?
    let floor: String?
    let entrance: String?
    let entranceCode: String?
    let comments: String?
}
