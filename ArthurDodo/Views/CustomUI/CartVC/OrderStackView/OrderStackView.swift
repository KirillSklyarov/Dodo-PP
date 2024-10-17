//
//  OrderStackView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 17.10.2024.
//

import UIKit

final class OrderStackView: UIStackView {

    // MARK: - Properties&Callbacks
    private lazy var orderView = OrderView()
    private lazy var cartProductTableView = CartProductTableView()

    var onEmptyCart: (() -> Void)?
    var onItemDeletedFromCart: (() -> Void)?
    var onCountIncreased: (() -> Void)?
    var onChangeItem: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    func setNewData(_ countOfItems: Int, totalPrice: Int) {
        orderView.setNewData(countOfItems, totalPrice: totalPrice)
    }

    func uploadOrder() {
        cartProductTableView.uploadOrder()
    }
}

// MARK: - Setup UI
private extension OrderStackView {
    func setupUI() {
        [orderView, cartProductTableView].forEach(addArrangedSubview)
        axis = .vertical
        spacing = 10
    }
}

// MARK: - Setup Actions
private extension OrderStackView {
    func setupActions() {
        cartProductTableView.onEmptyCart = { [weak self] in
            self?.onEmptyCart?()
        }
        cartProductTableView.onItemDeletedFromCart = { [weak self] in
            self?.onItemDeletedFromCart?()
        }
        cartProductTableView.onCountIncreased = { [weak self] in
            self?.onCountIncreased?()
        }

        cartProductTableView.onChangeItem = { [weak self] in
            self?.onChangeItem?()
        }
    }
}
