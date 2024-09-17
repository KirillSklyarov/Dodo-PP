//
//  CartSpOfferCollection.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 24.09.2024.
//

import UIKit

final class CartSpOfferCollection: UICollectionView {

    // MARK: - Properties
    private let collectionHeight: CGFloat = 120

    var onUpdateTableView: ( (Int) -> Void )?

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal

        super.init(frame: frame, collectionViewLayout: collectionLayout)
        configCollectionView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func configCollectionView() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        register(CartSpOfferCollectionCell.self, forCellWithReuseIdentifier: CartSpOfferCollectionCell.identifier)
        dataSource = self
        delegate = self
    }

    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: collectionHeight).isActive = true
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension CartSpOfferCollection: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartSpOfferCollectionCell.identifier, for: indexPath) as? CartSpOfferCollectionCell else { return UICollectionViewCell() }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionHeight
        return CGSize(width: width, height: height)
    }
}

extension CartSpOfferCollection: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let page = Int((scrollView.contentOffset.x + (0.5 * pageWidth)) / pageWidth)
        onUpdateTableView?(page)
    }
}
