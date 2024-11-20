//
//  OrderDetailsView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 26.10.2024.
//

import UIKit

final class OrderDetailsView: UIStackView {

    // MARK: - UI Properties
    private lazy var itemView = DodoCoinsView(title: "4 товара", value: "1660", textColor: AppColors.grayFont)
    private lazy var discountView = DodoCoinsView(title: "Скидка по акции", value: "-60", textColor: AppColors.grayFont)
    private lazy var deliveryView = DodoCoinsView(title: "Доставка", value: "Бесплатно", textColor: AppColors.grayFont)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func setCountOfItems(_ count: Int) {
        itemView.setNewCountValue(count)
    }

    func setTotalPrice(_ totalPrice: Int) {
        itemView.setTotalPrice(totalPrice)
    }

    func setDodoCoins(_ DodoCoins: Int) {
        discountView.setTotalPrice(DodoCoins)
    }
}

// MARK: - Setup UI
private extension OrderDetailsView {
     func setupUI() {
        [itemView, discountView, deliveryView].forEach { addArrangedSubview($0) }
        axis = .vertical
        spacing = 8
    }
}

