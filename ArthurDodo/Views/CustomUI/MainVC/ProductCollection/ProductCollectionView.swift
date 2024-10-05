//
//  ProductCollectionView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import UIKit

final class ProductCollectionView: UICollectionView {

    // MARK: - Properties&Callbacks
    var onUpdateTableView: ( (IndexPath) -> Void )?
    var onCellSelected: ( (FoodItems) -> Void )?
    var onChangeCategoryName: ( (IndexPath) -> Void)?

    private let cellHeight: CGFloat = 150
    private let leftPadding: CGFloat = 0
    private let rightPadding: CGFloat = 0

    private var isCollectionScrolling = false

    // MARK: - Init
    override init(frame: CGRect = .zero,
                  collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        super.init(frame: frame, collectionViewLayout: layout)
        configCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func configCollectionView() {
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        register(ProductCollectionCell.self, forCellWithReuseIdentifier: ProductCollectionCell.identifier)
        dataSource = self
        delegate = self
        translatesAutoresizingMaskIntoConstraints = false
    }

    func setIsScrolling(_ isScrolling: Bool) {
        isCollectionScrolling = isScrolling
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ProductCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionCell.identifier, for: indexPath) as? ProductCollectionCell else { return UICollectionViewCell() }
        let item = categories[indexPath.section].items[indexPath.row]
        cell.configureCell(pizza: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = categories[indexPath.section].items[indexPath.row]
        onCellSelected?(item)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: cellHeight)
    }
}

// MARK: - ScrollViewDelegate
extension ProductCollectionView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(isCollectionScrolling)
        if !isCollectionScrolling {
            let index = indexPathsForVisibleItems.sorted()
            let correctIndex = index[1]
            onChangeCategoryName?(correctIndex)
        }
    }
}
