import UIKit

enum DismissButtonType {
    case standard
    case chevron
    case storiesWhite
}

final class AppDismissButtonView: UIView {

    // MARK: - UI Properties
    private lazy var dismissButton = AppButtons(type: .grayXmark)

    // MARK: - Properties&Callbacks
    private let viewSize: CGFloat = 40
    var onButtonTapped: (() -> Void)?

    init(type: DismissButtonType) {
        super.init(frame: .zero)
        configure(type)
        setupUI()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppDismissButtonView {
    func configure(_ type: DismissButtonType) {
        switch type {
        case .standard:
            setColors(xColor: .white, backgroundColor: AppColors.backgroundGray.withAlphaComponent(0.2))

        case .chevron: setChevron()
        case .storiesWhite:
            setColors(xColor: AppColors.buttonGray, backgroundColor: .white)
        }
    }
}

// MARK: - Setup actions
private extension AppDismissButtonView {
    func setupAction() {
        setupDismissButtonAction()
    }

    func setupDismissButtonAction() {
        dismissButton.onButtonTapped = { [weak self] in
            self?.onButtonTapped?()
        }
    }
}

// MARK: - Setup UI
private extension AppDismissButtonView {
    func setupUI() {
        heightAnchor.constraint(equalToConstant: viewSize).isActive = true
        widthAnchor.constraint(equalToConstant: viewSize).isActive = true

        layer.cornerRadius = viewSize / 2
        layer.masksToBounds = true

        addSubviews(dismissButton)
        
        setupLayout()
    }

    func setupLayout() {
        dismissButton.setConstraints()
    }
}

// MARK: - Supporting methods
private extension AppDismissButtonView {
    func setColors(xColor: UIColor, backgroundColor: UIColor) {
        let image = UIImage(systemName: "xmark")?.withTintColor(xColor, renderingMode: .alwaysOriginal)
        dismissButton.setImage(image, for: .normal)
        self.backgroundColor = backgroundColor
    }

    func setChevron() {
        let image = UIImage(systemName: "chevron.left")?.withTintColor(AppColors.grayFont, renderingMode: .alwaysOriginal)
        dismissButton.setImage(image, for: .normal)
    }
}
