//
//  ProfileButtonView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 10.10.2024.
//

import UIKit

enum ProfileButtonImages: String {
    case chat = "phone.circle.fill"
    case profile = "hexagon.fill"
}

final class ProfileButtonView: UIView {

    // MARK: - Properties
    private let viewSize: CGFloat = 40
    var onButtonTapped: (() -> Void)?

    // MARK: - UI Properties
    private lazy var myButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(myButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init
    init(frame: CGRect = .zero, type: ProfileButtonImages) {
        super.init(frame: frame)
        configUI()
        setImage(type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IB Actions
    @objc private func myButtonTapped() {
        onButtonTapped?()
    }

    private func setImage(_ type: ProfileButtonImages) {
        let image = UIImage(systemName: type.rawValue)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        myButton.setImage(image, for: .normal)
    }

    // MARK: - Private methods
    private func configUI() {
        backgroundColor = AppColors.backgroundGray

        heightAnchor.constraint(equalToConstant: viewSize).isActive = true
        widthAnchor.constraint(equalToConstant: viewSize).isActive = true

        layer.cornerRadius = viewSize / 2
        layer.masksToBounds = true

        addSubviews(myButton)

        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            myButton.topAnchor.constraint(equalTo: topAnchor),
            myButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            myButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            myButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
