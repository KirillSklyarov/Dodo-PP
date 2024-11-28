import UIKit

enum AppButtonType {
    case decrementCount
    case incrementCount
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

private extension AppButtonsDS {
    func configureLabel(type: AppButtonType, text: String?) {
        switch type {
        case .decrementCount:
            let image = UIImage(systemName: "minus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            setImage(image, for: .normal)
            addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        case .incrementCount:
            let image = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            setImage(image, for: .normal)
            addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }

    @objc func buttonTapped() {
        onButtonTapped?()
    }
}
