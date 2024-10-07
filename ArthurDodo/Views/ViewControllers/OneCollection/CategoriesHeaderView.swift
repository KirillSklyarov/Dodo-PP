//
//  CategoriesHeader.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 06.10.2024.
//

import UIKit

final class CategoriesHeaderView: UICollectionReusableView {

    // MARK: - Properties
    static let identifier: String = "CategoriesHeaderView"
    private let viewHeight: CGFloat = 40
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10

    var onCategorySelected: ((CategoriesNames) -> Void)?

    // MARK: - UI Properties
    private lazy var headerCollectionView = CategoryHeaderCollectionView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        collectionCellSelected()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getCategory(_ categoryName: String) {
        headerCollectionView.selectCat(categoryName)
    }

    func collectionCellSelected() {
        headerCollectionView.onUpdateProductsCollectionView = { [weak self] categoryName in
            self?.onCategorySelected?(categoryName)
        }
    }

    // MARK: - Private methods
    private func setupConstraints() {
        addSubviews(headerCollectionView)

        NSLayoutConstraint.activate([
            headerCollectionView.topAnchor.constraint(equalTo: topAnchor),
            headerCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

