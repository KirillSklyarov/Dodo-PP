import UIKit

enum CartButtonViewType {
    case itemDetail
    case cart
}

final class AppCartButtonView: UIView {

    var cartButton: AppButtons?
    private var isCart: Bool = false
    private var currentPrice = 0

    var onCartButtonTapped: (() -> Void)?

    init(type: CartButtonViewType) {
        super.init(frame: .zero)
        configure(type)
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension AppCartButtonView {
    func updatePrice(_ price: Int) {
        currentPrice = price
        let title = if isCart {
            "Оформить заказ на \(price) ₽"
        } else {
            "В корзину за \(price) ₽"
        }
        cartButton?.setNewTitle(title)
    }

    func getCurrentPrice() -> Int {
        currentPrice
    }
}

private extension AppCartButtonView {
    func configure(_ type: CartButtonViewType) {
        let blurView = AppBlurView()

        switch type {
        case .itemDetail: isCart = false
        case .cart: isCart = true
        }

        cartButton = AppButtons(type: .cartOrange)
        guard let cartButton else { return }
        addSubviews(blurView, cartButton)

        heightAnchor.constraint(equalToConstant: 90).isActive = true
        blurView.setConstraints()

        NSLayoutConstraint.activate([
            cartButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            cartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    func setupActions() {
        cartButton?.onButtonTapped = { [weak self] in
            guard let self else { print("Self is nil"); return }
            onCartButtonTapped?()
        }
    }
}
