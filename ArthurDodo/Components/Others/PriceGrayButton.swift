//
//  PriceGrayButton.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 23.10.2024.
//

import UIKit

final class PriceGrayButton: UIButton {

    // MARK: - Properties
    private let cornerRadius: CGFloat = 14
    private let buttonWidth: CGFloat = 100

    var priceButtonTapped: ( () -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension PriceGrayButton {
    private func setupUI() {
        titleLabel?.font = AppFonts.semibold14
        setTitleColor(.white, for: .normal)
        backgroundColor = AppColors.buttonGray
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        addTarget(self, action: #selector (didTap), for: .touchUpInside)

        setupLayout()
    }

    @objc private func didTap() {
        priceButtonTapped?()
    }

    func setupLayout() {
        widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
    }
}

// MARK: - Set right price
extension PriceGrayButton {
    func setPrice(_ item: Item) {
        let itemPrice = getPrice(item)
        setTitle(itemPrice, for: .normal)
    }

    private func getPrice(_ item: Item) -> String {
        if let oneSize = item.itemSize.oneSize {
            return "\(oneSize.price) ₽"
        } else {
            let price = item.itemSize.medium?.price ?? 0
            return "от \(price) ₽"
        }
    }
}
