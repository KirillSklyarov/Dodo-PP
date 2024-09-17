//
//  ScrollUpButton.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 27.09.2024.
//

import UIKit

final class ScrollUpButton: UIButton {

    var onScrollUpButtonTapped: (() -> Void)?

    private let buttonSize: CGFloat = 40

    override init(frame: CGRect) {
        super.init(frame: frame)
        configButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configButton() {
        let image = UIImage(systemName: "chevron.up")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        backgroundColor = .darkGray
        setImage(image, for: .normal)
        addTarget(self, action: #selector(scrollUpButtonTapped), for: .touchUpInside)
        widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }

    @objc private func scrollUpButtonTapped() {
        onScrollUpButtonTapped?()
    }

}
