//
//  backgroundView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 03.10.2024.
//

import UIKit

final class BackgroundView: UIView {

    private let cornerRadius: CGFloat = 20

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

    private func configUI(){
        backgroundColor = AppColors.backgroundGray
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        guard let superview else { print("You have no superview"); return }

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }
}
