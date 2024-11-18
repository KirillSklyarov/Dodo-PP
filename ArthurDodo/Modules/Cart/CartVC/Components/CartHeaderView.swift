import UIKit

final class CartHeaderView: UIView {

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
    private let leftInset: CGFloat = 10

    var onDismissButtonTapped: (() -> Void)?

    // MARK: - Init
    init(frame: CGRect = .zero, title: String? = nil) {
        super.init(frame: frame)
        setTitle(title)
        configUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setTitle(_ title: String?) {
        if let title { titleLabel.text = title }
    }

    // MARK: - IB Actions
    @objc private func closeButtonTapped() {
        onDismissButtonTapped?()
    }

    // MARK: - Public methods
    func getViewHeight() -> CGFloat {
        viewHeight
    }
}

// MARK: - Setup UI
private extension CartHeaderView {
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
