//
//  ToppingsStackView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 17.10.2024.
//

import UIKit

final class ItemsToAddStackView: UIStackView {

    // MARK: - UI Properties
    private lazy var itemsToAddHeader = OrderView(title: "Добавить к заказу?")
    private lazy var itemsToAddCollectionView = AddToCartCollectionView()

    var onNewItemToAddToCart: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension ItemsToAddStackView {
    func setupUI() {
        addArrangedSubview(itemsToAddHeader)
        addArrangedSubview(itemsToAddCollectionView)
        axis = .vertical
        spacing = 10
    }

    func setupLayout() {

    }
}

// MARK: - Setup Actions
private extension ItemsToAddStackView {
    func setupActions() {
        itemsToAddCollectionView.onNewItemToAddToCart = { [weak self] in
            self?.onNewItemToAddToCart?()
        }
    }
}
