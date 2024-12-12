import UIKit

enum ViewHeight {
    case small
    case large
}

// Заблюренный header на экране Product Details (и на EditProduct)
final class ProductHeaderView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(type: .smallHeader, alignment: .center, numberOfLines: 0)
    private lazy var dismissButton = AppDismissButtonView(type: .standard)
    private lazy var blurView = AppBlurView()

    private lazy var contentStackView = setupContentStackView()

    // MARK: - Properties
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

    // Метод позволяет менять высоту у вью (сначала выключаем текущий констреинт, определяем правильную высоту, потом выставляем констреинт и активируем его). Так как мы используем две разные высоты (для Product details у нас большая высота - 110, а для экрана EditProduct - 60), то и в этом методе мы можем менять высоту передавая туда параметр
    func setViewHeight(_ height: ViewHeight) {
        heightConstraint?.isActive = false

        switch height {
        case .small: heightConstraint = heightAnchor.constraint(equalToConstant: 60)
        case .large: heightConstraint = heightAnchor.constraint(equalToConstant: 110)
        }
        
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
        setViewHeight(.large)
        setupBlurConstraints()
        setupContentStackLayout()
    }

    func setupBlurConstraints() {
        blurView.setConstraints()
    }

    func setupContentStackLayout() {
        contentStackView.setLocalConstraints(bottom: 10, left: 10, right: 50)
    }

    func setupContentStackView() -> UIStackView {
        let contentStackView = AppStackView([dismissButton, titleLabel], axis: .horizontal, spacing: 10)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return contentStackView
    }
}
