//
//  StoriesCollectionView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 18.09.2024.
//

import UIKit

final class StoriesCollectionView: UICollectionView {

    private let collectionHeight: CGFloat = 120
    private let leftPadding: CGFloat = 0
    private let rightPadding: CGFloat = 0
    private let topPadding: CGFloat = 0

    private let cellWidth: CGFloat = 90

    var onUpdateTableView: ( (IndexPath) -> Void )?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: collectionHeight)

        super.init(frame: frame, collectionViewLayout: layout)
        configCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        setupLayout()
    }

    func setupLayout() {
        guard let superview else { print("You must add StoriesCollectionView to a view"); return }

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leftPadding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: rightPadding),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: topPadding),
            heightAnchor.constraint(equalToConstant: collectionHeight)
        ])
    }

    private func configCollectionView() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        register(StoriesCollectionCell.self, forCellWithReuseIdentifier: StoriesCollectionCell.identifier)
        dataSource = self
        delegate = self
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension StoriesCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoriesCollectionCell.identifier, for: indexPath) as? StoriesCollectionCell else { return UICollectionViewCell() }
        let title = categories[indexPath.row].header
        cell.configHeader(title)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)

        deselectFirstCategory(collectionView, indexPath)
        designChosenCategory(collectionView, indexPath)
        onUpdateTableView?(indexPath)
    }

    func selectFirstCategory(_ collectionView: UICollectionView) {
        let firstCategoryIndexPath = IndexPath(row: 0, section: 0)
        onUpdateTableView?(firstCategoryIndexPath)
        designChosenCategory(collectionView, firstCategoryIndexPath)
    }

    private func designChosenCategory(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell else { print("Hey1"); return }
        cell.setTitleColor(.black)
    }

    private func deselectFirstCategory(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        let firstIndexPath = IndexPath(row: 0, section: 0)
        if indexPath != firstIndexPath {
            guard let cell = collectionView.cellForItem(at: firstIndexPath) as? CategoryViewCell else { return }
            cell.setTitleColor(.lightGray)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell else { return }
        cell.setTitleColor(.lightGray)
    }
}
