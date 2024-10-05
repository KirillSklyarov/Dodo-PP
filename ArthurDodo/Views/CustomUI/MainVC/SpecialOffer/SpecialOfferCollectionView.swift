//
//  SpecialOfferCollectionView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 19.09.2024.
//

import UIKit

final class SpecialOfferCollectionView: UICollectionView {

    // MARK: - Properties
    private let collectionHeight: CGFloat = 90
    private let itemWidth: CGFloat = 210
    private let leftPadding: CGFloat = 0
    private let rightPadding: CGFloat = 0

    var onUpdateTableView: ( (IndexPath) -> Void )?

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.itemSize = CGSize(width: itemWidth, height: collectionHeight)

        super.init(frame: frame, collectionViewLayout: collectionLayout)
        configCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        setupLayout()
    }

    // MARK: - Private methods
    private func setupLayout() {
        guard let superview else { print("You must add SpecialOfferCollectionView to superview"); return }

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leftPadding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: rightPadding),
            heightAnchor.constraint(equalToConstant: collectionHeight)
        ])
    }

    private func configCollectionView() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        register(SpecialOfferCollectionCell.self, forCellWithReuseIdentifier: SpecialOfferCollectionCell.identifier)
        dataSource = self
        delegate = self
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SpecialOfferCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpecialOfferCollectionCell.identifier, for: indexPath) as? SpecialOfferCollectionCell else { return UICollectionViewCell() }
        return cell
    }
}
