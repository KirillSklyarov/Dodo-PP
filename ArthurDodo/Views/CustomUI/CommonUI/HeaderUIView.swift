//
//  HeaderUIView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 17.09.2024.
//

import UIKit

final class HeaderView: UIView {

    // MARK: - Properties
    private let imageSize: CGFloat = 30
    private let buttonSize: CGFloat = 30
    private let viewHeight: CGFloat = 30

    private let leftPadding: CGFloat = 20
    private let rightPadding: CGFloat = -20

    var onProfileButtonTapped: (() -> Void)?

    // MARK: - UI Properties
    private lazy var courierImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "figure.walk.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Укажите адрес доставки"
        label.textColor = .white
        return label
    }()
    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return imageView
    }()
    private lazy var profileButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "person.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var contentContainer = UIView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        setupLayout()
    }

    @objc private func profileButtonTapped() {
        onProfileButtonTapped?()
    }

    // MARK: - Private methods
    private func setupLayout() {
        guard let superview else { print("You must add HeaderView to a view before setting up layout"); return }

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leftPadding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: rightPadding),
            heightAnchor.constraint(equalToConstant: viewHeight)
        ])
    }

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubviews(contentContainer)

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        setupContentContainer()
    }

    private func setupContentContainer() {
        contentContainer.addSubviews(courierImageView, addressLabel, chevronImageView, profileButton)

        NSLayoutConstraint.activate([
            courierImageView.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            courierImageView.leadingAnchor.constraint(equalTo: leadingAnchor),

            addressLabel.centerYAnchor.constraint(equalTo: courierImageView.centerYAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: courierImageView.trailingAnchor, constant: 10),

            chevronImageView.topAnchor.constraint(equalTo: addressLabel.topAnchor),
            chevronImageView.leadingAnchor.constraint(equalTo: addressLabel.trailingAnchor, constant: 10),

            profileButton.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            profileButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor)
        ])
    }
}
