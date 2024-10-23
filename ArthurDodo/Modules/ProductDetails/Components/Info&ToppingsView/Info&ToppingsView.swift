//
//  Info&ToppingsView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 23.10.2024.
//

import UIKit

final class InfoAndToppingsView: UIView {

    // MARK: - Properties
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10

    // MARK: - UI Properties
    private lazy var infoAndToppingsStack = InfoAndToppingsStack()

    var onShowPopupVC: ((UIViewController) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InfoAndToppingsView {
    func getCartView(_ cart: CartButtonView) {
        infoAndToppingsStack.getButtonView(cart)
    }

    func updateUI(productDetails: WeightPrice) {
        infoAndToppingsStack.updateUI(productDetails: productDetails)
    }

    func getItem(_ item: Item) {
        infoAndToppingsStack.getItemFromVC(item)
    }

    func updateWeight(_ weight: Int) {
        infoAndToppingsStack.updateWeight(weight)
    }

    func updateIngredientsAndWeight(_ item: Item) {
        infoAndToppingsStack.updateUIWithItem(item)
    }
}

private extension InfoAndToppingsView {
    func setupActions() {
        setupInfoButtonAction()
    }

    func setupInfoButtonAction() {
        infoAndToppingsStack.onShowPopupVC = { [weak self] popupVC in
            self?.onShowPopupVC?(popupVC)
        }
    }
}

// MARK: - Setup UI
private extension InfoAndToppingsView {
    func setupUI() {
        addSubviews(infoAndToppingsStack)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            infoAndToppingsStack.topAnchor.constraint(equalTo: topAnchor),
            infoAndToppingsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset),
            infoAndToppingsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightInset),
            infoAndToppingsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
