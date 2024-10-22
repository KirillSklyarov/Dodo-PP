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

    var onCartButtonTapped: ( (Int) -> Void )?

    // MARK: - UI Properties
    private lazy var cartButton = CartButton(isHidden: false, isCart: false)
    private lazy var blurView = CustomBlurView()

    // MARK: - Init
    override init(frame: CGRect) {
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

    func updatePrice(_ price: Int) {
        currentPrice = price
        let title = "В корзину за \(price) ₽"
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
            onCartButtonTapped?(currentPrice)
        }
    }
}
