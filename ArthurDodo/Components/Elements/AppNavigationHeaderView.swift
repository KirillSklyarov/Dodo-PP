import UIKit

// Вью хэдера где указан заголовок и оранжевая кнопка Закрыть
final class AppNavigationHeaderView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(type: .maxiTitle)
    private lazy var dismissButton = AppButtons(type: .orangeDismiss)

    // MARK: - Properties&Callbacks
    private let viewHeight: CGFloat = 60

    var onDismissButtonTapped: (() -> Void)?

    // MARK: - Init
    init(frame: CGRect = .zero, title: String? = nil) {
        super.init(frame: frame)
        setTitle(title)
        configUI()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension AppNavigationHeaderView {
    func configUI() {
        addSubviews(dismissButton, titleLabel)
        setupLayout()
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true

        setupDismissButtonConstraints()
        setupTitleLabelConstraints()
    }

    func setupDismissButtonConstraints() {
        dismissButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
    }

    func setupTitleLabelConstraints() {
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}

// MARK: - Setup Actions
private extension AppNavigationHeaderView {
    func setupAction() {
        dismissButton.onButtonTapped = { [weak self] in
            self?.onDismissButtonTapped?()
        }
    }
}

// MARK: - Supporting methods
private extension AppNavigationHeaderView {
    func setTitle(_ title: String?) {
        if let title { titleLabel.text = title }
    }
}
