import UIKit

// Нижний блок экрана "Доставка" с ценой заказа
final class OrderTotalPriceView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(type: .smallHeader, text: "Стоимость заказа", numberOfLines: 1)
    private lazy var priceLabel = AppLabel(type: .smallHeader, alignment: .right)
    private lazy var contentStack = AppStackView([titleLabel, priceLabel], axis: .horizontal, alignment: .center)

    // MARK: - Other Properties
    private let viewHeight: CGFloat = 50

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
extension OrderTotalPriceView {
    func updateUI(with totalPrice: Int) {
        priceLabel.text = "\(totalPrice) ₽"
    }
}

// MARK: - Setup UI
private extension OrderTotalPriceView {
    func setupUI() {
        addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        contentStack.setConstraints()
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
    }
}
