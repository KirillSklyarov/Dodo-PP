import UIKit

enum PaymentMethod: Int, CaseIterable {
    case cbp
    case card
    case sberPay
    case cash

    var title: String {
        switch self {
        case .cbp: return "СБП"
        case .card: return "Картой в приложении"
        case .sberPay: return "SberPay"
        case .cash: return "Наличными"
        }
    }

    static func getMethodFrom(_ method: String) -> PaymentMethod? {
        switch method {
        case "СБП": return .cbp
        case "Картой в приложении": return .card
        case "SberPay": return .sberPay
        case "Наличными": return .cash
        default: print("No method found"); return nil
        }
    }

    var image: UIImage? {
        switch self {
        case .cbp: return UIImage(named: "sbp")
        case .card: return UIImage(systemName: "creditcard.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        case .sberPay: return UIImage(named: "sberpay")
        case .cash: return UIImage(systemName: "wallet.bifold.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        }
    }
}
