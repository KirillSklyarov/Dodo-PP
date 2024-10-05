//
//  ButtonViewFooter.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 22.09.2024.
//

import UIKit

final class CartButtonViewFooter: UIView {

    // MARK: - Properties
    var onCloseButtonTapped: ( (Int) -> Void )?
    private let viewHeight: CGFloat = 90
    private var currentPrice = 0

    // MARK: - UI Properties
    private lazy var cartButton = CartButton(isHidden: false)
    private lazy var blurView = CustomBlurView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        configureCartButton()
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

    // MARK: - Private methods
    private func configureCartButton() {
        let title = "В корзину за 0 ₽"
        cartButton.setNewTitle(title)
        let image = UIImage()
        cartButton.setImage(image, for: .normal)

        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
    }

    @objc private func cartButtonTapped() {
        onCloseButtonTapped?(currentPrice)
    }

    private func configUI() {
        addSubviews(blurView, cartButton)
        setupLayout()
    }

    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        setupBlurConstraints()
        setupCartButtonConstraints()
    }

    private func setupBlurConstraints() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupCartButtonConstraints() {
        NSLayoutConstraint.activate([
            cartButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            cartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}
