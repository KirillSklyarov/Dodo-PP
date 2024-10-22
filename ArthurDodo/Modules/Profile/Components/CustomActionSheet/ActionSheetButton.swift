//
//  ActionSheetButton.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 17.10.2024.
//

import UIKit

final class ActionSheetButton: UIButton {

    // MARK: - Properties
    private let buttonHeight: CGFloat = 60
    var onButtonTapped: (() -> Void)?

    // MARK: - Init
    init(frame: CGRect = .zero, title: String, roundedCorners: Bool = false) {
        super.init(frame: frame)
        setupUI()
        setRoundedCorners(roundedCorners)
        setTitle(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setTitle(_ title: String) {
        let attributedTitle = NSAttributedString(
            string: title,
            attributes:
                [.foregroundColor: AppColors.buttonOrange,
                 .font: AppFonts.semibold22,
                ])
        setAttributedTitle(attributedTitle, for: .normal)
    }

    private func setRoundedCorners(_ roundedCorners: Bool) {
        layer.cornerRadius = roundedCorners ? 10 : 0
        layer.masksToBounds = true
    }
}

// MARK: - Setup UI
private extension ActionSheetButton {
    func setupUI() {
        backgroundColor = AppColors.backgroundGray
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        setupLayout()
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }

    @objc func buttonTapped() {
        onButtonTapped?()
    }
}
