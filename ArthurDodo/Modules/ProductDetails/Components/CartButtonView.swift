//
//  ButtonViewFooter.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 22.09.2024.
//

import UIKit

final class CartButtonView: UIView {

    // MARK: - Properties
    private let viewHeight: CGFloat = 90
    private let topInset: CGFloat = 10
    private let leftInset: CGFloat = 20
    private let rightInset: CGFloat = -20

    private var currentPrice = 0

    var onCartButtonTapped: ( () -> Void )?

    // MARK: - UI Properties
    private var cartButton: CartButton
    private lazy var blurView = CustomBlurView()

    // MARK: - Init
    init(frame: CGRect = .zero, isHidden: Bool = false, title: String? = nil, isNeedImage: Bool = false, isCart: Bool = false) {
        cartButton = CartButton(isHidden: isHidden, isNeedImage: isNeedImage, isCart: isCart)
        super.init(frame: frame)
        configUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func getHeight() -> CGFloat {
        viewHeight
    }

    func getCurrentPrice() -> Int {
        currentPrice
    }

    // В зависимости корзина или нет, то меняется label на кнопке
    func updatePrice(_ price: Int) {
        currentPrice = price
        let title = if cartButton.isCart {
            "Оформить заказ на \(price) ₽"
        } else {
            "В корзину за \(price) ₽"
        }
        cartButton.setNewTitle(title)
    }
}

// MARK: - Setup UI
private extension CartButtonView {
    func configUI() {
        addSubviews(blurView, cartButton)
        setupLayout()
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        setupBlurConstraints()
        setupCartButtonConstraints()
    }

    func setupBlurConstraints() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupCartButtonConstraints() {
        NSLayoutConstraint.activate([
            cartButton.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            cartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset),
            cartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightInset)
        ])
    }
}

// MARK: - Setup Actions
private extension CartButtonView {
    func setupActions() {
        cartButton.onButtonTapped = { [weak self] in
            guard let self else { return }
            onCartButtonTapped?()
        }
    }
}
