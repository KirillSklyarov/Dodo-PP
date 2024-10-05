//
//  ProductCollectionView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import UIKit

final class ProductCollectionView: UICollectionView {

    // MARK: - Properties
    var onUpdateTableView: ( (IndexPath) -> Void )?
    var onChangeCategoryName: ( (IndexPath) -> Void)?
    var products: [FoodItems] = []
    private let cellHeight: CGFloat = 150
    private let leftPadding: CGFloat = 0
    private let rightPadding: CGFloat = 0

    var isCollectionScrolling = false

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


//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
//
//        deselectFirstCategory(collectionView, indexPath)
//        designChosenCategory(collectionView, indexPath)
//        onUpdateTableView?(indexPath)
//    }
//
//    func selectFirstCategory(_ collectionView: UICollectionView) {
//        let firstCategoryIndexPath = IndexPath(row: 0, section: 0)
//        onUpdateTableView?(firstCategoryIndexPath)
//        designChosenCategory(collectionView, firstCategoryIndexPath)
//    }

//    private func designChosenCategory(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductCollectionCell else { print("Hey2"); return }
//        cell.titleLabel.textColor = .white
//    }
//
//    private func deselectFirstCategory(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
//        let firstIndexPath = IndexPath(row: 0, section: 0)
//        if indexPath != firstIndexPath {
//            guard let cell = collectionView.cellForItem(at: firstIndexPath) as? ProductCollectionCell else { return }
//            cell.titleLabel.textColor = .darkGray.withAlphaComponent(0.4)
//        }
//    }

//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductCollectionCell else { return }
//        cell.titleLabel.textColor = .darkGray.withAlphaComponent(0.4)
//    }
//}

