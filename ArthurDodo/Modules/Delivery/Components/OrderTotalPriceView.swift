//
//  OrderTotalPriceView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 26.10.2024.
//

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
        label.text = "500 ₽"
        return label
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, priceLabel])
        stackView.axis = .horizontal
        return stackView
    }()

    // MARK: - Other Properties
    private let viewHeight: CGFloat = 50

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension OrderTotalPriceView {
    func setup() {
        addSubviews(stackView)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            heightAnchor.constraint(equalToConstant: viewHeight)
        ])
    }
}
