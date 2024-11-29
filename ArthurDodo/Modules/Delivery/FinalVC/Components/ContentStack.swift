import UIKit

final class FinalVCContentStackView: UIStackView {

    // MARK: - UI properties
    private lazy var titleLabel = AppLabel(type: .headerTitle, text: "Ваш заказ успешно оформлен")
    private lazy var doneImageView = AppImageView(type: .checkmark)
    private lazy var dismissInfoLabel = AppLabel(type: .promoTitle, text: "Это окно закроется через \(dismissDelay ?? 5) секунд")

    // MARK: - Other properties
    private let leftInset: CGFloat = 20
    private let rightInset: CGFloat = -20
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
        [titleLabel, doneImageView, dismissInfoLabel].forEach(addArrangedSubview)
        axis = .vertical
        alignment = .center
        spacing = 20
    }
}
