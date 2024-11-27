import Foundation

struct ItemSize: Equatable, Codable {
    let small: WeightPrice?
    let medium: WeightPrice?
    let large: WeightPrice?
    let oneSize: WeightPrice?

    func getWeightAndPriceViaIndex(_ index: Int) -> WeightPrice? {
        switch index {
        case 0: return small
        case 1: return medium
        case 2: return large
        default: return nil
        }
    }
}

