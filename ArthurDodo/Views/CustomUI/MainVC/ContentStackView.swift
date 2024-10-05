//
//  ContentStackView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 04.10.2024.
//

import UIKit

final class ContentStackView: UIStackView {

    private let topPadding: CGFloat = 10
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let elementSpacing: CGFloat = 10

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        setupLayout()
    }

//    let stackView = UIStackView(arrangedSubviews: [storiesCollectionView, specialOfferLabel, specialOfferCollectionView, placeholderView, productsCollectionView])

    private func setupUI() {
        axis = .vertical
        spacing = elementSpacing
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        guard let superview else { print("You must add ContentStackView to a superview"); return }

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: topPadding),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leftPadding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: rightPadding),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }
}
