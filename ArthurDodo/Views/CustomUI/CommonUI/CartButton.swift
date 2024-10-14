//
//  CartButton.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 18.09.2024.
//

import UIKit

final class CartButton: UIButton {

    // MARK: - Properties
    private var totalPrice = 0
    var onCartButtonTapped: (() -> Void)?
    private let buttonHeight: CGFloat = 50
    private let dataStorage = DataStorage.shared

    // MARK: - Init
    init(frame: CGRect = .zero, isHidden: Bool, title: String? = nil, isCart: Bool? = nil) {
        super.init(frame: frame)
        configButton(isHidden: isHidden)
        setupLayout()
        if let title { setNewTitle(title) }
        if let isCart {
            if !isCart { self.configuration?.image = nil }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func setNewTitle(_ title: String) {
        configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .foregroundColor: UIColor.white,
            .font: AppFonts.bold18])
        )
    }

    func setNewPrice(_ price: Int) {
        totalPrice += price
        let title = "\(totalPrice) ₽"
        configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .foregroundColor: UIColor.white,
            .font: AppFonts.bold18]))
    }

    func resetPrice() {
        totalPrice = 0
    }

    func getTotalCartPriceFromStorage() {
        let totalPrice = dataStorage.getTotalOrderPrice()
        let title = "\(totalPrice) ₽"
        setNewTitle(title)
    }

    // MARK: - Private methods
    private func configButton(isHidden: Bool) {
        let image = UIImage(systemName: "cart.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let title = "0 ₽"

        var config = UIButton.Configuration.plain()
        config.imagePadding = 10
        config.title = title
        config.image = image
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .foregroundColor: UIColor.white,
            .font: AppFonts.bold18]
        ))
        config.background.backgroundColor = AppColors.buttonOrange
        config.cornerStyle = .capsule
        configuration = config

        self.isHidden = isHidden
        addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }

    @objc private func cartButtonTapped() {
        onCartButtonTapped?()
    }
}
