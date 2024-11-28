import UIKit

final class ApplyPromoButton: UIButton {

    var onButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: .zero)
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
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonTapped() {
        onButtonTapped?()
    }
}
