//
//  AddToppingsCollectionView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 20.09.2024.
//

import UIKit

final class AddToppingsCollectionView: UICollectionView {

    // MARK: - Properties
    var onToppingSelected: ( (Int) -> Void )?
    var onDataFetchedSuccessfully: (() -> Void)?

    var toppings: [Topping] = []

    private let cellHeight: CGFloat = 100
    private let lineSpacing: CGFloat = 5
    var collectionHeight: CGFloat {
        let rowCount = CGFloat(toppings.count / 3)
        return rowCount * cellHeight + lineSpacing
    }

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        let customLayout = configLayout()
        collectionViewLayout = customLayout
        uploadDataFromServer()
        configCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Upload Data from Storage
private extension AddToppingsCollectionView {
    // Загружаем начинки только один раз, потом они не меняются
    func uploadDataFromServer() {
        if toppings.isEmpty {
            loadDataFromStorage()
        }
    }

    // Загружаем начинки
    func loadDataFromStorage() {
        DataStorage.shared.fetchToppings()
        DataStorage.shared.onToppingsFetchedSuccessfully = { [weak self] fetchedToppings in
            guard let self else { return }
            toppings = fetchedToppings
            setupCollectionHeight()
            onDataFetchedSuccessfully?()
        }
    }
}

// MARK: - Setup UI
private extension AddToppingsCollectionView {
    func setupCollectionHeight() {
        heightAnchor.constraint(equalToConstant: collectionHeight).isActive = true
    }

    func configLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let correctWidth = (UIScreen.main.bounds.width - (15 * 2) - 20) / 3
        layout.itemSize = CGSize(width: correctWidth, height: cellHeight)
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = 1
        return layout
    }

    func configCollectionView() {
        backgroundColor = .clear
        allowsMultipleSelection = true
        isScrollEnabled = false
        register(AddToppingsCollectionViewCell.self, forCellWithReuseIdentifier: AddToppingsCollectionViewCell.identifier)
        dataSource = self
        delegate = self
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension AddToppingsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        toppings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddToppingsCollectionViewCell.identifier, for: indexPath) as? AddToppingsCollectionViewCell else { return UICollectionViewCell() }
        let topping = toppings[indexPath.row]
        cell.configCell(topping)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AddToppingsCollectionViewCell else { return }
        cell.chooseTopping()
        let priceToAdd = cell.getChosenToppingPrice()
        onToppingSelected?(priceToAdd)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AddToppingsCollectionViewCell else { return }
        cell.hideTopping()
        let priceToRemove = -cell.getChosenToppingPrice()
        onToppingSelected?(priceToRemove)
    }
}
