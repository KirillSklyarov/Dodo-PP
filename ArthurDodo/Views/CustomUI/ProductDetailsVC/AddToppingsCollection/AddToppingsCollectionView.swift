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

    private var toppings: [Topping] = []
    private var item: FoodItems?

    private let cellHeight: CGFloat = 100
    private let lineSpacing: CGFloat = 5
    private var collectionHeight: CGFloat?

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

    func getItem(_ item: FoodItems) {
        self.item = item
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

    // Загружаем ВСЕ начинки
    func loadDataFromStorage() {
        DataStorage.shared.fetchToppings()
        DataStorage.shared.onToppingsFetchedSuccessfully = { [weak self] fetchedToppings in
            guard let self else { return }
            filterToppings(fetchedToppings)
            setupCollectionHeight()
            onDataFetchedSuccessfully?()
        }
    }

    // Отбираем только нужные нам начинки
    func filterToppings(_ fetchedToppings: [Topping]) {
        if let arrayOfToppings = item?.toppings {
            toppings = fetchedToppings.filter { arrayOfToppings.contains($0.name) }
        }
    }
}

// MARK: - Setup UI
private extension AddToppingsCollectionView {
    func setupCollectionHeight() {
        calculationOfHeight()
        heightAnchor.constraint(equalToConstant: collectionHeight ?? 0).isActive = true
    }

    // Рассчитываем высоту таблицы в зависимости от кол-ва топпингов
    func calculationOfHeight() {
        let count = toppings.count
        switch count {
        case 0: collectionHeight = 0
        case 1...3: collectionHeight = cellHeight
        default:
            let rowCount = CGFloat(toppings.count) / CGFloat(3)
            collectionHeight = (rowCount + 1)*cellHeight + (lineSpacing*rowCount)
        }
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
