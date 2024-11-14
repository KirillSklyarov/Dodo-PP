import UIKit

final class ProductHeaderView: UIView {

    // MARK: - Properties
    private let buttonSize: CGFloat = 40
    private let viewHeight: CGFloat = 110
    private let titleLabelPadding: CGFloat = 60
    private let buttonLeftPadding: CGFloat = 20
    private let buttonBottomPadding: CGFloat = 10

    var onCloseButtonTapped: (() -> Void)?

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.bold20
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var dismissButton = DismissButtonView()
    private lazy var blurView = CustomBlurView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        closeButtonTapped()
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

    func getViewHeight() -> CGFloat {
        viewHeight
    }
}

// MARK: - Setup actions
private extension ProductHeaderView {
    func closeButtonTapped() {
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
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
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
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: titleLabelPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -titleLabelPadding)
        ])
    }
}
