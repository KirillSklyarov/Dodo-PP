import UIKit

final class OrderTotalPriceView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(text: "Стоимость заказа", textColor: .white, font: .bold(size: 22), numberOfLines: 1)
    private lazy var priceLabel = AppLabel(textColor: .white, font: .bold(size: 22), alignment: .right)
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
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            heightAnchor.constraint(equalToConstant: viewHeight)
        ])
    }
}
