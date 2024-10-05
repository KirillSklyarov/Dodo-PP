//
//  HeaderCollectionView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 18.09.2024.
//

import UIKit

final class CategoryHeaderCollectionView: UICollectionView {

    var onUpdateProductsCollectionView: ( (Int) -> Void )?
    private let viewHeight: CGFloat = 50
    private let cornerRadius: CGFloat = 20
    private var previousInd: IndexPath = []

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionHeadersPinToVisibleBounds = true
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        super.init(frame: frame, collectionViewLayout: layout)
        configCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        setupLayout()
    }

    func getPreviousInd() -> IndexPath {
        previousInd
    }

    func setPreviousInd(_ indexPath: IndexPath)  {
        previousInd = indexPath
    }

    func selectCell(_ indexPath: IndexPath) {
        deSelectPreviousCell()
        if let cell = cellForItem(at: indexPath) as? CategoryViewCell {
            selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            cell.setTitleColor(.white)
            setPreviousInd(indexPath)
        }
    }

    private func deSelectPreviousCell() {
        if let previousCell = cellForItem(at: previousInd) as? CategoryViewCell {
            previousCell.setTitleColor(AppColors.grayFont)
        }
    }

    private func setupLayout() {
        guard let superview else { print("You must add CategoryCollectionView to superview"); return }

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            heightAnchor.constraint(equalToConstant: viewHeight)
        ])
    }

    private func configCollectionView() {
        backgroundColor = UIColor(hex: "222222")
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
        showsHorizontalScrollIndicator = false
        register(CategoryViewCell.self, forCellWithReuseIdentifier: CategoryViewCell.identifier)
        dataSource = self
        delegate = self
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension CategoryHeaderCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.identifier, for: indexPath) as? CategoryViewCell else { return UICollectionViewCell() }
        let title = categories[indexPath.row].header
        cell.configHeader(title, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onUpdateProductsCollectionView?(indexPath.row)
        selectCell(indexPath)
    }

    private func designChosenCategory(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell else { print("Hey2"); return }
        cell.setTitleColor(.white)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell else { return }
        cell.setTitleColor(.darkGray.withAlphaComponent(0.4))
    }
}
