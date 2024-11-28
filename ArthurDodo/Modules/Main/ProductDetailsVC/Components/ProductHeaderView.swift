import UIKit

final class ProductHeaderView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabelDS(type: .headerTitle)
    private lazy var dismissButton = DismissButtonView()
    private lazy var blurView = AppBlurView()

    private lazy var contentStackView = setupContentStackView()

    // MARK: - Properties
    private let viewHeight: CGFloat = 110

    private var heightConstraint: NSLayoutConstraint?

    var onDismissButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        dismissButtonTapped()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension ProductHeaderView {
    func updateTitle(_ title: String) {
        titleLabel.text = title
    }

    // Метод позволяет менять высоту у вью (сначала выключаем текущий констреинт, определяем правильную высоту, потом выставляем констреинт и активируем его)
    func setViewHeight(_ height: CGFloat = 0) {
        heightConstraint?.isActive = false
        let correctHeight = height == 0 ? viewHeight : height
        heightConstraint = heightAnchor.constraint(equalToConstant: correctHeight)
        heightConstraint?.isActive = true
    }
}

// MARK: - Setup actions
private extension ProductHeaderView {
    func dismissButtonTapped() {
        dismissButton.onButtonTapped = { [weak self] in
            self?.onDismissButtonTapped?()
        }
    }
}

// MARK: - Setup UI
private extension ProductHeaderView {
    func setupUI() {
        addSubviews(blurView)

        blurView.contentView.addSubviews(contentStackView)

        setupLayout()
    }

    func setupLayout() {
        setViewHeight()
        setupBlurConstraints()
        setupContentStackLayout()
    }

    func setupBlurConstraints() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupContentStackLayout() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -50),
            contentStackView.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -10)
        ])

    }

    func setupContentStackView() -> UIStackView {
        let contentStackView = AppStackView([dismissButton, titleLabel], axis: .horizontal, spacing: 10)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return contentStackView
    }
}
