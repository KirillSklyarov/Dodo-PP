//
//  SpecialOfferCollectionView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 10.10.2024.
//

import UIKit

final class SpecialOfferCollectionView: UICollectionView {

    // MARK: - Properties
    private let cellHeight: CGFloat = 150
    private let cellWidth: CGFloat = 150
    private let lineSpacing: CGFloat = 5
    private var collectionHeight: CGFloat = 150

    var onToppingSelected: ( (Int) -> Void )?

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        let customLayout = configLayout()
        collectionViewLayout = customLayout
        configureCollectionView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Layout
private extension SpecialOfferCollectionView {
    func configureCollectionView() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        register(SpecialOfferProfileCell.self, forCellWithReuseIdentifier: SpecialOfferProfileCell.identifier)
        dataSource = self
        delegate = self
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: collectionHeight).isActive = true
    }

    func configLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let correctWidth = (UIScreen.main.bounds.width - 20)
        layout.itemSize = CGSize(width: correctWidth, height: cellHeight)
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = 1
        return layout
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SpecialOfferCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpecialOfferProfileCell.identifier, for: indexPath) as? SpecialOfferProfileCell else { return UICollectionViewCell() }
        cell.configureCell(indexPath)
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? AddToppingsCollectionViewCell else { return }
//        cell.chooseTopping()
//        let priceToAdd = cell.getChosenToppingPrice()
//        onToppingSelected?(priceToAdd)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? AddToppingsCollectionViewCell else { return }
//        cell.hideTopping()
//        let priceToRemove = -cell.getChosenToppingPrice()
//        onToppingSelected?(priceToRemove)
//    }
}