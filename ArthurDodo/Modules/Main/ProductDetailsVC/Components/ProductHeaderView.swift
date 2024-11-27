import UIKit

final class ProductHeaderView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(textColor: .white, font: .bold(size: 20), alignment: .center)
    private lazy var dismissButton = DismissButtonView()
    private lazy var blurView = AppBlurView()

    // MARK: - Properties
    private let buttonSize: CGFloat = 40
    private let viewHeight: CGFloat = 110
    private let labelLeftPadding: CGFloat = 60
    private let labelRightPadding: CGFloat = -60
    private let buttonLeftPadding: CGFloat = 20
    private let buttonBottomPadding: CGFloat = 10

    private var heightConstraint: NSLayoutConstraint?

    var onCloseButtonTapped: (() -> Void)?

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
            self?.onCloseButtonTapped?()
        }
    }
}

// MARK: - Setup UI
private extension ProductHeaderView {
    func setupUI() {
        addSubviews(blurView, dismissButton, titleLabel)
        setupLayout()
    }

    func setupLayout() {
        setViewHeight()

        setupBlurConstraints()
        setupDismissButtonConstraints()
        setupTitleLabelConstraints()
    }

    func setupBlurConstraints() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupDismissButtonConstraints() {
        NSLayoutConstraint.activate([
            dismissButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -buttonBottomPadding),
            dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonLeftPadding),
        ])
    }

    func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: labelLeftPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: labelRightPadding),
        ])
    }
}
