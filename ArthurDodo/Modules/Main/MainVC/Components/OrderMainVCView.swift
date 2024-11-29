import UIKit

final class OrderMainVCView: UIView {

    // MARK: - UI Properties
    private lazy var orderLabel = AppLabel(type: .orderTitle)
    private lazy var statusLabel = AppLabel(type: .orderStatus)

    private lazy var labelsStackView = AppStackView([orderLabel, statusLabel], axis: .vertical, alignment: .leading, distribution: .fillEqually)
    private lazy var contentStackView = AppStackView([labelsStackView], axis: .horizontal, alignment: .center)

    // MARK: - Properties
    private let viewHeight: CGFloat = 80
    private let cornerRadius: CGFloat = 10
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10

    private var viewHeightConstraint: NSLayoutConstraint?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension OrderMainVCView {
    // Если активный заказ есть, то высота хорошая, если нет заказа, то 0
    func calculateHeight(_ isOrder: Bool) {
        viewHeightConstraint?.constant = isOrder ? viewHeight : 0
    }

    func getOrder(_ order: Order, _ totalPrice: Int) {
        updateUI(with: order, totalPrice)
    }
}

// MARK: - Supporting methods
private extension OrderMainVCView {
    // Обновляем все лейблы
    func updateUI(with order: Order, _ totalPrice: Int) {
        orderLabel.text = "Заказ № \(totalPrice)"
        statusLabel.text = order.status.rawValue
    }
}

// MARK: - Setup UI
private extension OrderMainVCView {
    func setupUI() {
        backgroundColor = AppColors.backgroundGray
        layer.cornerRadius = cornerRadius
        clipsToBounds = true

        addSubviews(contentStackView)

        setupLayout()
    }
}

// MARK: - Setup Layout
private extension OrderMainVCView {
    func setupLayout() {
        viewHeightConstraint = heightAnchor.constraint(equalToConstant: viewHeight)
        viewHeightConstraint?.isActive = true

        setupContentStackViewLayout()
    }

    func setupContentStackViewLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
