import UIKit

struct AppConstants {
    static let sizeCases = ["25 cм", "30 см", "35 см"]
    static let doughCases = ["Традиционное", "Тонкое"]
    static let appBuild = "1"
}

struct AppFonts {
    static let basicFont = UIFont.systemFont(ofSize: 30)

    static let regular12 = UIFont(name: "SFProRounded-Regular", size: 12) ?? basicFont
    static let regular14 = UIFont(name: "SFProRounded-Regular", size: 14) ?? basicFont
    static let regular16 = UIFont(name: "SFProRounded-Regular", size: 16) ?? basicFont
    static let regular18 = UIFont(name: "SFProRounded-Regular", size: 18) ?? basicFont
    static let regular20 = UIFont(name: "SFProRounded-Regular", size: 20) ?? basicFont

    static let semibold12 = UIFont(name: "SFProRounded-Semibold", size: 12) ?? basicFont
    static let semibold14 = UIFont(name: "SFProRounded-Semibold", size: 14) ?? basicFont
    static let semibold16 = UIFont(name: "SFProRounded-Semibold", size: 16) ?? basicFont
    static let semibold18 = UIFont(name: "SFProRounded-Semibold", size: 18) ?? basicFont
    static let semibold20 = UIFont(name: "SFProRounded-Semibold", size: 20) ?? basicFont
    static let semibold22 = UIFont(name: "SFProRounded-Semibold", size: 20) ?? basicFont

    static let medium12 = UIFont(name: "SFProRounded-Medium", size: 12) ?? basicFont
    static let medium14 = UIFont(name: "SFProRounded-Medium", size: 14) ?? basicFont
    static let medium16 = UIFont(name: "SFProRounded-Medium", size: 16) ?? basicFont

    static let bold14 = UIFont(name: "SFProRounded-Bold", size: 14) ?? basicFont
    static let bold16 = UIFont(name: "SFProRounded-Bold", size: 16) ?? basicFont
    static let bold18 = UIFont(name: "SFProRounded-Bold", size: 18) ?? basicFont
    static let bold20 = UIFont(name: "SFProRounded-Bold", size: 20) ?? basicFont
    static let bold22 = UIFont(name: "SFProRounded-Bold", size: 22) ?? basicFont
    static let bold24 = UIFont(name: "SFProRounded-Bold", size: 24) ?? basicFont
    static let bold26 = UIFont(name: "SFProRounded-Bold", size: 26) ?? basicFont
    static let bold30 = UIFont(name: "SFProRounded-Bold", size: 30) ?? basicFont
    static let bold34 = UIFont(name: "SFProRounded-Bold", size: 34) ?? basicFont
    static let bold40 = UIFont(name: "SFProRounded-Bold", size: 40) ?? basicFont
}

enum AppFontsEnum {
    case regular(size: CGFloat)
    case bold(size: CGFloat)
    case semibold(size: CGFloat)
    case medium(size: CGFloat)

    var font: UIFont {
        switch self {
        case .regular(size: let size): return UIFont(name: "SFProRounded-Regular", size: size)!
        case .medium(size: let size): return UIFont(name: "SFProRounded-Medium", size: size)!
        case .semibold(size: let size): return UIFont(name: "SFProRounded-Semibold", size: size)!
        case .bold(size: let size): return UIFont(name: "SFProRounded-Bold", size: size)!
        }
    }
}

struct AppColors {
    static let backgroundGray = UIColor(hex: "242424")
    static let backgroundBlack = UIColor(hex: "171717")
    static let buttonGray = UIColor(hex: "363636")
    static let dodoCoinsBlue = UIColor(hex: "5f4eca")
    static let buttonOrange = UIColor(hex: "ff6400")
    static let grayFont = UIColor(hex: "727272")
    static let sberGreen = UIColor(hex: "06c906")
}

enum AppColorsEnum {
    case backgroundBlack
    case backgroundGray
    case buttonGray
    case buttonOrange
    case darkGray
    case dodoCoinsBlue
    case grayFont
    case productBackground
    case sberGreen
    case white

    var color: UIColor {
        switch self {
        case .backgroundBlack: return .black
        case .backgroundGray: return  UIColor(hex: "222222")
        case .buttonGray: return UIColor(hex: "363636")
        case .darkGray: return .darkGray
        case .dodoCoinsBlue: return UIColor(hex: "5f4eca")
        case .buttonOrange: return UIColor(hex: "ff6400")
        case .grayFont: return UIColor(hex: "959595")
        case .productBackground: return UIColor(hex: "485460")
        case .sberGreen: return UIColor(hex: "06c906")
        case .white: return .white
        }
    }
}
