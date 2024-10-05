//
//  PromoButton.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 27.09.2024.
//

import UIKit

final class PromoButton: UIButton {

    // MARK: - Properties
    private let buttonHeight: CGFloat = 50
    private let buttonWidth: CGFloat = 250

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPromoButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func setupPromoButton() {
        setTitle("Ввести промокод", for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        backgroundColor = .darkGray.withAlphaComponent(0.4)
        layer.cornerRadius = 10
        layer.cornerRadius = 20
        layer.masksToBounds = true
        heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
    }
}
