import UIKit

enum LabelType {
    case name
    case header
    case dodoCoinsTitle
    case dodoCoinsSubtitle
    case addressName
    case addressTime
    case addressTitle
    case orderTitle
    case orderStatus
    case categoryTitle
    case itemSubtitle
    case headerTitle
    case coinsTitle
    case topicsTitle
    case promoTitle
    case legalTitle
    case orangeChange
    case priceGrayLabel
    case promoCellTitle
    case timeLabel
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
        case .coinsTitle:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.semibold(size: 12).font
            textAlignment = .center
            numberOfLines = 1
        case .addressName:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.regular(size: 14).font
            textAlignment = .left
            numberOfLines = 0
        case .topicsTitle:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.regular(size: 14).font
            textAlignment = .center
            numberOfLines = 1
        case .promoCellTitle:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.bold(size: 14).font
            textAlignment = .left
            numberOfLines = 3
            adjustsFontSizeToFitWidth = true
        case .name:
            self.text = text
            self.textColor = .white
            font = AppFontsEnum.semibold(size: 16).font
            textAlignment = .left
            numberOfLines = 0
            adjustsFontSizeToFitWidth = true
        case .timeLabel:
            self.text = text
            self.textColor = .white
            font = AppFontsEnum.semibold(size: 18).font
            textAlignment = .center
            numberOfLines = 0
            adjustsFontSizeToFitWidth = true
        case .legalTitle:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.semibold(size: 20).font
            textAlignment = .left
            numberOfLines = 0
            adjustsFontSizeToFitWidth = true
        case .orderStatus:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.bold(size: 22).font
            textAlignment = .left
            numberOfLines = 1
            adjustsFontSizeToFitWidth = true
        case .headerTitle:
            self.text = text
            self.textColor = .white
            font = AppFontsEnum.bold(size: 22).font
            textAlignment = .center
            numberOfLines = 0
            adjustsFontSizeToFitWidth = true
        case .header:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.bold(size: 26).font
            textAlignment = .left
            numberOfLines = 1
        case .dodoCoinsTitle:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.bold(size: 40).font
            textAlignment = .left
            numberOfLines = 1
        case .dodoCoinsSubtitle:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.bold(size: 14).font
            textAlignment = .left
            numberOfLines = 1
            backgroundColor = .white.withAlphaComponent(0.2)
            layer.cornerRadius = 14
            clipsToBounds = true
            contentInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        case .priceGrayLabel:
            self.text = text
            self.textColor = textColor
            font = AppFontsEnum.bold(size: 12).font
            textAlignment = .center
            numberOfLines = 1
            backgroundColor = AppColors.buttonGray
            layer.cornerRadius = 14
            layer.masksToBounds = true
            heightAnchor.constraint(equalToConstant: 25).isActive = true
        case .itemSubtitle:
            self.text = text
            self.textColor = AppColors.grayFont
            font = AppFontsEnum.regular(size: 12).font
            textAlignment = .left
            numberOfLines = 0
            adjustsFontSizeToFitWidth = true
        case .categoryTitle:
            self.text = text
            self.textColor = AppColors.grayFont
            font = AppFontsEnum.bold(size: 14).font
            textAlignment = .center
            numberOfLines = 1
            heightAnchor.constraint(equalToConstant: 40).isActive = true
        case .orderTitle:
            self.text = text
            self.textColor = AppColors.grayFont
            font = AppFontsEnum.semibold(size: 14).font
            textAlignment = .left
            numberOfLines = 0
        case .promoTitle:
            self.text = text
            self.textColor = AppColors.grayFont
            font = AppFontsEnum.semibold(size: 16).font
            textAlignment = .left
            numberOfLines = 0
        case .addressTitle:
            self.text = text
            self.textColor = AppColors.grayFont
            font = AppFontsEnum.semibold(size: 18).font
            textAlignment = .left
            numberOfLines = 0

        case .addressTime:
            self.text = text
            self.textColor = AppColors.sberGreen
            font = AppFontsEnum.regular(size: 12).font
            textAlignment = .left
            numberOfLines = 1
        case .orangeChange:
            self.text = text
            self.textColor = AppColors.buttonOrange
            font = AppFontsEnum.semibold(size: 16).font
            textAlignment = .right
            numberOfLines = 1
        }
    }

    private func getPrice(_ item: Item) -> String {
        if let oneSize = item.itemSize.oneSize {
            return "\(oneSize.price) ₽"
        } else {
            let price = item.itemSize.medium?.price ?? 0
            return "от \(price) ₽"
        }
    }
}
