import UIKit

enum LabelType {
    case priceGrayRoundLabel
    case tinyTitle
    case smallTitle
    case basicTitle
    case maxiTitle
    case smallHeader
    case header
    case maxiHeader
}

final class AppLabel: InsetLabel {

    init(type: LabelType, text: String? = nil, textColor: UIColor? = .white, alignment: NSTextAlignment = .left, numberOfLines: Int = 0) {
        super.init(frame: .zero)
        configureLabel(type: type, text: text, textColor: textColor, alignment: alignment, numberOfLines: numberOfLines)
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
    func configureLabel(type: LabelType, text: String?, textColor: UIColor?, alignment: NSTextAlignment, numberOfLines: Int) {
        switch type {
        case .priceGrayRoundLabel:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.bold(size: 12).font
            textAlignment = .center
            self.numberOfLines = 1
            backgroundColor = .white.withAlphaComponent(0.2)
            layer.cornerRadius = 14
            clipsToBounds = true
            contentInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        case .tinyTitle:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.regular(size: 12).font
            textAlignment = alignment
        case .smallTitle:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.regular(size: 14).font
            textAlignment = alignment
            self.numberOfLines = numberOfLines
        case .basicTitle:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.semibold(size: 16).font
            textAlignment = alignment
            self.numberOfLines = numberOfLines
        case .maxiTitle:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.semibold(size: 18).font
            textAlignment = alignment
            self.numberOfLines = 0
        case .smallHeader:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.bold(size: 22).font
            textAlignment = alignment
            self.numberOfLines = numberOfLines
        case .header:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.bold(size: 26).font
            textAlignment = alignment
            self.numberOfLines = 1
        case .maxiHeader:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.bold(size: 40).font
            textAlignment = alignment
            self.numberOfLines = 1
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
