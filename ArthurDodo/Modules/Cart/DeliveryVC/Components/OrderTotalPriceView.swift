import UIKit

final class OrderTotalPriceView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.bold22
        label.text = "Стоимость заказа"
        return label
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.bold22
        label.textAlignment = .right
        return label
    }()
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, priceLabel])
        stackView.axis = .horizontal
        return stackView
    }()

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
