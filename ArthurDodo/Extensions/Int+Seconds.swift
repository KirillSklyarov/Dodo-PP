import Foundation

extension Int {
    func getRightFormOfSeconds() -> String {
        let remainder = self % 10
        let remainderHundred = self % 100

        if remainderHundred >= 11 && remainderHundred <= 19 {
            return "секунд"
        }

        switch remainder {
        case 1: return "секунду"
        case 2, 3, 4: return "секунды"
        default: return "секунд"
        }
    }
}
