import UIKit

final class DodoCoinsStackView: UIStackView {

    // MARK: - UI Properties
    private lazy var itemView = DodoCoinsView()
    private lazy var coinsView = DodoCoinsView(title: "Додокоины", value: "+61")
    private lazy var deliveryView = DodoCoinsView(title: "Доставка", value: "Бесплатно")

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension DodoCoinsStackView {
    func setCountOfItems(_ count: Int) {
        itemView.setNewCountValue(count)
    }

    func setTotalPrice(_ totalPrice: Int) {
        itemView.setTotalPrice(totalPrice)
    }

    func setDodoCoins(_ DodoCoins: Int) {
        coinsView.setTotalPrice(DodoCoins)
    }
}

// MARK: - Setup UI
private extension DodoCoinsStackView {
    func setupUI() {
        [itemView, coinsView, deliveryView].forEach { addArrangedSubview($0) }
        axis = .vertical
        spacing = 8
    }
}
