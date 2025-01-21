import UIKit
import AppUIComponentsSPM

// Это вью, которая появляется при оформлении заказа (с номером заказа и его статусом)
final class OrderMainVCView: UIView {

    // MARK: - UI Properties
    private lazy var orderLabel = AppLabel(type: .smallTitle, textColor: AppColors.grayFont)
    private lazy var statusLabel = AppLabel(type: .smallHeader)

    private lazy var labelsStackView = AppStackView([orderLabel, statusLabel], axis: .vertical, alignment: .leading, distribution: .fillEqually)
    private lazy var contentStackView = AppStackView([labelsStackView], axis: .horizontal, alignment: .center)

    // MARK: - Properties
    private let viewHeight: CGFloat = 80
    private let cornerRadius: CGFloat = 10

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

    func getOrder(_ orderStatus: String, _ totalPrice: Int) {
        updateUI(with: orderStatus, totalPrice)
    }
}

// MARK: - Supporting methods
private extension OrderMainVCView {
    // Обновляем все лейблы
    func updateUI(with orderStatus: String, _ totalPrice: Int) {
        orderLabel.text = "Заказ № \(totalPrice)"
        statusLabel.text = orderStatus
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
        contentStackView.setConstraints(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
}
