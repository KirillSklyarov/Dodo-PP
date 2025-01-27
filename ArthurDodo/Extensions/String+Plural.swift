import Foundation

extension String {
    func pluralize(for count: Int) -> String {
        let countAbs = abs(count) % 100
        let countMod10 = countAbs % 10

        if countAbs >= 11 && countAbs <= 14 {
            return self + "ов"
        }

        switch countMod10 {
        case 1:
            return self
        case 2, 3, 4:
            return self + "а"
        default:
            return self + "ов"
        }
    }
}
