//
//  SpecialOfferCollectionCell.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 19.09.2024.
//

import UIKit

final class SpecialOfferCollectionCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier: String = "SpecialOfferCollectionCell"
    private let imageViewSize: CGFloat = 90
    private let buttonWidthMultiplier: CGFloat = 0.85

    var onPriceButtonTapped: ( (String) -> Void )?

    // MARK: - UI Properties
    private lazy var pizzaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold16
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    private lazy var priceButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = AppFonts.semibold14
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.buttonGray
        button.layer.cornerRadius = 14
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configureCell(_ item: Item) {
        pizzaImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.name
        let itemPrice = item.itemSize.medium?.price ?? 0
//            .itemSize[.medium]?.price ?? 0
        let priceString = "от \(itemPrice) ₽"
        priceButton.setTitle(priceString, for: .normal)
    }
}

// MARK: - Setup UI
private extension SpecialOfferCollectionCell {
    func setupSubviews() {

        let contentContainer = setupContentContainer()

        contentView.addSubviews(contentContainer)

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func setupContentContainer() -> UIView {

        let contentContainer = UIView()

        let stack = UIStackView(arrangedSubviews: [titleLabel, priceButton])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading

        contentContainer.addSubviews(pizzaImageView, stack)

        NSLayoutConstraint.activate([
            pizzaImageView.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            pizzaImageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),

            stack.centerYAnchor.constraint(equalTo: pizzaImageView.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: pizzaImageView.trailingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),

            priceButton.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: buttonWidthMultiplier)
        ])

        return contentContainer
    }
}
