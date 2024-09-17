//
//  DodoCoinsStackView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 29.09.2024.
//

import UIKit

final class DodoCoinsStackView: UIStackView {

    private lazy var itemView = DodoCoinsView()
    private lazy var coinsView = DodoCoinsView(title: "Додокоины", value: "+61")
    private lazy var deliveryView = DodoCoinsView(title: "Доставка", value: "Бесплатно")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCountOfItems(_ count: Int) {
        itemView.setNewCountValue(count)
    }

    func setTotalPrice(_ totalPrice: Int) {
        itemView.setTotalPrice(totalPrice)
    }

    func setDodoCoins(_ DodoCoins: Int) {
        coinsView.setTotalPrice(DodoCoins)
    }

    private func setup() {
        [itemView, coinsView, deliveryView].forEach { addArrangedSubview($0) }
        axis = .vertical
        spacing = 8
    }
}
