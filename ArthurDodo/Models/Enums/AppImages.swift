import Foundation

enum AppImages {
    case common(Common)
    case button(Button)
    case address(AddressSD)
    case main(Main)

    var image: String {
        switch self {
        case .common(let common): return common.rawValue
        case .button(let button): return button.rawValue
        case .address(let address): return address.rawValue
        case .main(let main): return main.rawValue
        }
    }
}


enum Common: String {
    case courier = "figure.hiking"
    case cartCircle = "cart.circle"
    case mapPin = "mappin"
    case hit = "hit2"
    case errorXmark = "xmark.circle"
    case dodoCoins = "dodoCoinsImage"
    case finalCheckmark = "checkmark.circle"
    case chosenTopping = "checkmark.circle.fill"
}

enum Button: String {
    case dismiss = "xmark"
    case chat = "phone.circle.fill"
    case profile = "hexagon.fill"
}

enum AddressSD: String {
    case orangePoint = "record.circle.fill"
    case pencil = "pencil"
}

enum Main: String {
    case chevronDown = "chevron.down"
}

