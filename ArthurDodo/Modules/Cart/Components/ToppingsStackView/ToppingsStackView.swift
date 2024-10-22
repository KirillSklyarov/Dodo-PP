//
//  ToppingsStackView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 17.10.2024.
//

import UIKit

final class ToppingsStackView: UIStackView {

    private lazy var toppingsHeader = OrderView(title: "Добавить к заказу?")
    private lazy var toppingsCollectionView = AddToCartCollectionView()

    var onNewItemToAddToCart: (() -> Void)?

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
private extension ToppingsStackView {
    func setupUI() {
        addArrangedSubview(toppingsHeader)
        addArrangedSubview(toppingsCollectionView)

        axis = .vertical
        spacing = 10
    }

    func setupLayout() {

    }
}

// MARK: - Setup Actions
private extension ToppingsStackView {
    func setupActions() {
        toppingsCollectionView.onNewItemToAddToCart = { [weak self] in
            self?.onNewItemToAddToCart?()
        }
    }
}
