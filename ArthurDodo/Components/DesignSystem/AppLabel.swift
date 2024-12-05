import UIKit

enum LabelType {
    case priceGrayRoundLabel
    case smallTitle
    case basicTitle
    case maxiTitle
    case smallHeader
    case header
    case maxiHeader
}

final class AppLabel: InsetLabel {

    init(type: LabelType, text: String? = nil, textColor: UIColor? = .white) {
        super.init(frame: .zero)
        configureLabel(type: type, text: text, textColor: textColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setPrice(_ item: Item) {
        let itemPrice = getPrice(item)
        self.text = itemPrice
    }
}

private extension AppLabel {
    func configureLabel(type: LabelType, text: String?, textColor: UIColor?) {
        switch type {
        case .priceGrayRoundLabel:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.bold(size: 12).font
            textAlignment = .center
            numberOfLines = 1
            backgroundColor = .white.withAlphaComponent(0.2)
            layer.cornerRadius = 14
            clipsToBounds = true
            contentInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        case .smallTitle:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.regular(size: 14).font
            textAlignment = .left
            numberOfLines = 0
        case .basicTitle:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.semibold(size: 16).font
            textAlignment = .left
            numberOfLines = 0
            adjustsFontSizeToFitWidth = true
        case .maxiTitle:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.semibold(size: 18).font
            textAlignment = .center
            numberOfLines = 0
            adjustsFontSizeToFitWidth = true
        case .smallHeader:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.bold(size: 22).font
            textAlignment = .left
            numberOfLines = 1
            adjustsFontSizeToFitWidth = true
        case .header:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.bold(size: 26).font
            textAlignment = .left
            numberOfLines = 1
        case .maxiHeader:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.bold(size: 40).font
            textAlignment = .left
            numberOfLines = 1
        }
    }

    func getPrice(_ item: Item) -> String {
        if let oneSize = item.itemSize.oneSize {
            return "\(oneSize.price) ₽"
        } else {
            let price = item.itemSize.medium?.price ?? 0
            return "от \(price) ₽"
        }
    }
}
