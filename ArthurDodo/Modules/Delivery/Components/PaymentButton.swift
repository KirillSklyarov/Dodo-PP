//
//  PaymentButton.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 26.10.2024.
//

import UIKit

final class PaymentButton: UIButton {

    // MARK: - Properties
    private let buttonHeight: CGFloat = 50

    var onButtonTapped: (() -> Void)?

    // MARK: - Init
    init(frame: CGRect = .zero, title: String? = nil) {
        super.init(frame: frame)
        configButton()
        setupLayout()
        if let title { setNewTitle(title) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func setNewTitle(_ title: String) {
        configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .foregroundColor: AppColors.backgroundBlack,
            .font: AppFonts.bold20])
        )
    }
}

// MARK: - Setup UI
private extension PaymentButton {
    func configButton() {
        let title = ""
        var config = UIButton.Configuration.plain()
        config.imagePadding = 10
        config.title = title
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .foregroundColor: UIColor.white,
            .font: AppFonts.bold20]
        ))
        config.background.backgroundColor = .white
        config.cornerStyle = .capsule
        configuration = config

        addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }

    @objc func cartButtonTapped() {
        onButtonTapped?()
    }
}
