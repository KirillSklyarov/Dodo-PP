//
//  ToppingsCollectionView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 26.09.2024.
//

import UIKit

final class AddToCartCollectionView: UICollectionView {

    // MARK: - Properties
    private let cellHeight: CGFloat = 215
    private let cellSpacing: CGFloat = 10

    private let countOfCellsInRow: CGFloat = 3
    private let leftAndRightPadding: CGFloat = 20

    private let numberOfElements = 5

    private var correctWidth: CGFloat {
        (UIScreen.main.bounds.width - (cellSpacing * 2) - leftAndRightPadding) / countOfCellsInRow
    }

    private let storage = DataStorage.shared
    private var itemsToAddToOrder: [Item] = []

    var onToppingSelected: ( (Int) -> Void )?
    var onNewItemToAddToCart: ( () -> Void )?

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        let customLayout = configLayout()
        collectionViewLayout = customLayout
        configCollectionView()
        getRandomToppings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getRandomToppings() {
        itemsToAddToOrder = storage.getRandomItems(numberOfElements)
    }

    // MARK: - Private methods
    private func configLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: correctWidth, height: cellHeight)
        return layout
    }

    private func configCollectionView() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        register(AddToCartCollectionCell.self, forCellWithReuseIdentifier: AddToCartCollectionCell.identifier)
        dataSource = self
        delegate = self

        setupLayout()
    }

    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension AddToCartCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfElements
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddToCartCollectionCell.identifier, for: indexPath) as? AddToCartCollectionCell else { return UICollectionViewCell() }
        let pizzaToAdd = itemsToAddToOrder[indexPath.row]
        cell.configCell(pizzaToAdd)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let positionToAdd = getOrderFromIndexPath(indexPath)
        addItemToOrder(positionToAdd)
    }

    private func getOrderFromIndexPath(_ indexPath: IndexPath) -> Order {
        let pizzaToAdd = itemsToAddToOrder[indexPath.row]
        let positionToAdd = Order(pizzaName: pizzaToAdd.name, imageName: pizzaToAdd.imageName, size: .small, dough: nil, weight: 12, price: pizzaToAdd.itemSize.small?.price ?? 0, isHit: pizzaToAdd.isHit)
        return positionToAdd
    }

    private func addItemToOrder(_ item: Order) {
        storage.sendToOrderStorage(item)
        onNewItemToAddToCart?()
    }
}
