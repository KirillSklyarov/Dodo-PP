import UIKit

final class CartVCHeader: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина"
        label.textColor = .white
        label.font = AppFonts.semibold18
        return label
    }()
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("Закрыть", for: .normal)
        button.setTitleColor(AppColors.buttonOrange, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Properties&Callbacks
    private let viewHeight: CGFloat = 60
    private let leftInset: CGFloat = 20

    var onCloseButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IB Actions
    @objc private func closeButtonTapped() {
        onCloseButtonTapped?()
    }

    // MARK: - Public methods
    func getViewHeight() -> CGFloat {
        viewHeight
    }
}

// MARK: - Setup UI
private extension CartVCHeader {
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
        NSLayoutConstraint.activate([
            dismissButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset),
        ])
    }

    func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
