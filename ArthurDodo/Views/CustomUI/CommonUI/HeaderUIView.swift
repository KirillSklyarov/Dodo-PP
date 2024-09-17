//
//  HeaderUIView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 17.09.2024.
//

import UIKit

final class HeaderView: UIView {

    private lazy var courierImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "figure.walk.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
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

    private lazy var smileButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "person.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()

    private lazy var contentContainer: UIView = {
        let view = UIView()
        return view
    }()

    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        heightAnchor.constraint(equalToConstant: 30).isActive = true

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
        contentContainer.addSubviews(courierImageView, addressLabel, chevronImageView, smileButton)

        NSLayoutConstraint.activate([
            courierImageView.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            courierImageView.leadingAnchor.constraint(equalTo: leadingAnchor),

            addressLabel.centerYAnchor.constraint(equalTo: courierImageView.centerYAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: courierImageView.trailingAnchor, constant: 10),

            chevronImageView.topAnchor.constraint(equalTo: addressLabel.topAnchor),
            chevronImageView.leadingAnchor.constraint(equalTo: addressLabel.trailingAnchor, constant: 10),

            smileButton.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            smileButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor)
        ])
    }
}
