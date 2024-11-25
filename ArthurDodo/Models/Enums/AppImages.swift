import Foundation

enum AppImages {
    case common(Common)
    case button(Button)

    var image: String {
        switch self {
        case .common(let common): return common.rawValue
        case .button(let button): return button.rawValue
        }
    }
}


enum Common: String {
    case courier = "figure.hiking"
    case cartCircle = "cart.circle"
    case mapPin = "mappin"
}

enum Button: String {
    case dismiss = "xmark"
    case chat = "phone.circle.fill"
    case profile = "hexagon.fill"
}

