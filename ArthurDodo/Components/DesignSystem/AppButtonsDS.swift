import UIKit

enum AppButtonType {
    case decrementCount
    case incrementCount
    case grayPrice
    case orangeDismiss
    case orangeApplyPromo
    case mapEdit
    case grayXmark
    case profileChat
    case personal
    case errorRetry
}

final class AppButtonsDS: UIButton {

    var onButtonTapped: (() -> Void)?

    init(type: AppButtonType, text: String? = nil) {
        super.init(frame: .zero)
        configureLabel(type: type, text: text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension AppButtonsDS {
    func setPrice(_ item: Item) {
        let itemPrice = getPrice(item)
        setTitle(itemPrice, for: .normal)
    }
}

private extension AppButtonsDS {
    func configureLabel(type: AppButtonType, text: String?) {
        switch type {
        case .decrementCount:
            let image = UIImage(systemName: "minus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            setImage(image, for: .normal)
        case .incrementCount:
            let image = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            setImage(image, for: .normal)
        case .grayPrice:
            titleLabel?.font = AppFonts.semibold14
            setTitleColor(.white, for: .normal)
            backgroundColor = AppColors.buttonGray
            layer.cornerRadius = 14
            clipsToBounds = true
            setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

            widthAnchor.constraint(equalToConstant: 90).isActive = true
        case .orangeDismiss:
            setTitle("Закрыть", for: .normal)
            setTitleColor(AppColors.buttonOrange, for: .normal)
        case .mapEdit:
            let image = UIImage(systemName: "pencil")?.withTintColor(AppColors.buttonGray, renderingMode: .alwaysOriginal)
            contentHorizontalAlignment = .fill
            contentVerticalAlignment = .fill
            setImage(image, for: .normal)
            frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        case .orangeApplyPromo:
            let title = "Применить"
            var config = UIButton.Configuration.filled()
            config.title = title
            config.attributedTitle = AttributedString(title, attributes: AttributeContainer([
                .font: AppFonts.bold14])
            )
            config.baseForegroundColor = .white
            config.baseBackgroundColor = AppColors.buttonOrange
            config.cornerStyle = .capsule
            configuration = config
        case .grayXmark:
            let image = UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            setImage(image, for: .normal)
        case .profileChat:
            let image = UIImage(systemName: "phone.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            setImage(image, for: .normal)
            backgroundColor = AppColors.backgroundGray
            heightAnchor.constraint(equalToConstant: 40).isActive = true
            widthAnchor.constraint(equalToConstant: 40).isActive = true
            layer.cornerRadius = 40 / 2
            layer.masksToBounds = true
        case .personal:
            let image = UIImage(systemName: "hexagon.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            setImage(image, for: .normal)
            backgroundColor = AppColors.backgroundGray
            heightAnchor.constraint(equalToConstant: 40).isActive = true
            widthAnchor.constraint(equalToConstant: 40).isActive = true
            layer.cornerRadius = 40 / 2
            layer.masksToBounds = true
        case .errorRetry:
            var config = UIButton.Configuration.filled()
            config.attributedTitle = AttributedString("Повторить", attributes: AttributeContainer([
                .font: AppFonts.bold16,
                .foregroundColor: AppColors.grayFont])
            )
            config.baseBackgroundColor = AppColors.buttonGray
            config.cornerStyle = .capsule
            configuration = config
        }

        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc func buttonTapped() {
        onButtonTapped?()
    }
}

// MARK: - Supporting methods
private extension AppButtonsDS {
    func getPrice(_ item: Item) -> String {
        if let oneSize = item.itemSize.oneSize {
            return "\(oneSize.price) ₽"
        } else {
            let price = item.itemSize.medium?.price ?? 0
            return "от \(price) ₽"
        }
    }
}
