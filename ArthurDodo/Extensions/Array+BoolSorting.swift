import Foundation

extension Array where Element == Address {
    func sortedMainFirst() -> [Address] {
        return self.sorted {
            ($0.isMain ? 0 : 1) < ($1.isMain ? 0 : 1)
        }
    }
}
