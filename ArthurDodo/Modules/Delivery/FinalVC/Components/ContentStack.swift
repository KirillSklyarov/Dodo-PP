import UIKit

final class FinalVCContentStackView: UIStackView {

    // MARK: - UI properties
    private lazy var titleLabel = AppLabel(type: .smallHeader, text: "Ваш заказ успешно оформлен")
    private lazy var doneImageView = AppImageView(type: .checkmark)
    private lazy var dismissInfoLabel = AppLabel(type: .basicTitle, text: "Это окно закроется через \(dismissDelay ?? 5) секунд", textColor: AppColors.grayFont)

    // MARK: - Other properties
    private var dismissDelay: Int?

    // MARK: - Init
    init(frame: CGRect = .zero, _ dismissDelay: Int? = nil) {
        super.init(frame: frame)
        self.dismissDelay = dismissDelay
        setupUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension FinalVCContentStackView {
    func updateTitle(_ seconds: Int) {
        let secondsString = seconds.getRightFormOfSeconds()
        dismissInfoLabel.text = "Это окно закроется через \(seconds) \(secondsString)"
    }
}

// MARK: - Setup UI
private extension FinalVCContentStackView {
    func setupUI() {
        setupUIElements()

        [titleLabel, doneImageView, dismissInfoLabel].forEach(addArrangedSubview)
        axis = .vertical
        alignment = .center
        spacing = 20
    }

    func setupUIElements() {
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }
}
