import Foundation

struct Address: Codable {
    let addressId: String
    var isMain: Bool
    let name: String
    var cityStreetHouse: String
    let apartment: String?
    let floor: String?
    let entrance: String?
    let entranceCode: String?
    let comments: String?
}
