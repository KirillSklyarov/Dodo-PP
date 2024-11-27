import UIKit

final class FinalVCContentStackView: UIStackView {

    // MARK: - UI properties
    private lazy var titleLabel = AppLabel(text: "Ваш заказ успешно оформлен", textColor: .grayFont, font: .bold(size: 34), alignment: .center)

    private lazy var doneImageView = AppImageView(viewImage: .common(.finalCheckmark), tintColor: .buttonOrange, squareSize: imageSize)

    private lazy var imageViewContainer: UIView = {
        let view = UIView()
        view.addSubviews(doneImageView)
        view.contentMode = .scaleAspectFill
        view.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        return view
    }()
    private lazy var dismissInfoLabel = AppLabel(text: "Это окно закроется через \(dismissDelay ?? 5) секунд", textColor: .grayFont, font: .semibold(size: 16), alignment: .center)

    // MARK: - Other properties
    private let leftInset: CGFloat = 20
    private let rightInset: CGFloat = -20
    private let imageSize: CGFloat = 100
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
        [titleLabel, imageViewContainer, dismissInfoLabel].forEach(addArrangedSubview)
        axis = .vertical
        spacing = 20

        setupImageViewContainerLayout()
    }

    func setupImageViewContainerLayout() {
        NSLayoutConstraint.activate([
            doneImageView.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor),
            doneImageView.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor)
        ])
    }
}
