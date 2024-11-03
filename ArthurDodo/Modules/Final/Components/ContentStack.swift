import UIKit

final class FinalVCContentStackView: UIStackView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш заказ успешно оформлен"
        label.textColor = .white
        label.font = AppFonts.bold34
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var doneImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "checkmark.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()
    private lazy var imageViewContainer: UIView = {
        let view = UIView()
        view.addSubviews(doneImageView)
        view.contentMode = .scaleAspectFill
        view.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        return view
    }()
    private lazy var dismissInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Это окно закроется через \(dismissDelay ?? 5) секунд"
        label.font = AppFonts.semibold16
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let imageSize: CGFloat = 100
    private var dismissDelay: Int?

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
        setupImageViewContainerLayout()
        axis = .vertical
        spacing = 20
    }

    func setupImageViewContainerLayout() {
        NSLayoutConstraint.activate([
            doneImageView.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor),
            doneImageView.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor)
        ])
    }
}
