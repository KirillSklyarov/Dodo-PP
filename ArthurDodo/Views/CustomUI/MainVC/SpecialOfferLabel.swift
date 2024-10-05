//
//  SpecialOfferLabel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 03.10.2024.
//

import UIKit

final class SpecialOfferLabel: UILabel {

    private let leftPadding: CGFloat = 0
    private let rightPadding: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        setupLayout()
    }

    private func configUI() {
        font = AppFonts.semibold16
        text = "Выгодно и вкусно"
        textColor = .white
        textAlignment = .left
        translatesAutoresizingMaskIntoConstraints = false
    }

    func setupLayout() {
        guard let superview else { print("You have to add SpecialOfferLabel to a view"); return}

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leftPadding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: rightPadding)
        ])
    }
}
