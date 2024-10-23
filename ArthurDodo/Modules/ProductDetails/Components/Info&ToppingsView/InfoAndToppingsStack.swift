//
//  InfoAndToppingsView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 15.10.2024.
//

import UIKit

final class InfoAndToppingsStack: UIStackView {

    // MARK: - Properties
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10

    // MARK: - UI Properties
    private lazy var ingredientsView = IngredientsView()
    private lazy var toppingsCollectionView = AddToppingsCollectionView()
    private var cart: CartButtonView?

    var onShowPopupVC: ((UIViewController) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAction()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Update UI
extension InfoAndToppingsStack {
    func getButtonView(_ cart: CartButtonView) {
        self.cart = cart
    }

    func updateUI(productDetails: WeightPrice) {
        let weight = productDetails.weight
        ingredientsView.updateWeight(weight)
        ingredientsView.setProductDetails(productDetails)
    }

    func updateUIWithItem(_ item: Item) {
        let ingredients = item.ingredients
        ingredientsView.updateIngredients(ingredients)
        let weight = item.itemSize.medium?.weight ?? 0
        ingredientsView.updateWeight(weight)
    }

    func getItemFromVC(_ item: Item) {
        toppingsCollectionView.getItem(item)
    }

    func updateWeight(_ weight: Int) {
        ingredientsView.updateWeight(weight)
    }
}

// MARK: - Setup UI
private extension InfoAndToppingsStack {
    func setupUI() {
        addArrangedSubview(ingredientsView)
        addArrangedSubview(toppingsCollectionView)
        axis = .vertical
        spacing = 5
    }
}

// MARK: - Setup actions
private extension InfoAndToppingsStack {
    func setupAction() {
        setupIngredientsViewAction()
        setupToppingsCollectionViewActions()
    }

    func setupIngredientsViewAction() {
        ingredientsView.onShowPopupVC = { [weak self] popupVC in
            self?.onShowPopupVC?(popupVC)
        }
    }

    func setupToppingsCollectionViewActions() {
        toppingsCollectionView.onToppingSelected = { [weak self] toppingPrice in
            guard let self,
                  let cart else { return }
            var currentPrice = cart.getCurrentPrice()
            currentPrice += toppingPrice
            print(currentPrice)
            cart.updatePrice(currentPrice)
        }

        toppingsCollectionView.onDataFetchedSuccessfully = { [weak self] in
            DispatchQueue.main.async {
                self?.toppingsCollectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }

}
