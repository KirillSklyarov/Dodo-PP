//
//  CartSpOfferCollectionCell.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 24.09.2024.
//

import UIKit

final class CartSpOfferCollectionCell: UICollectionViewCell {

    static let identifier: String = "CartSpOfferCollectionCell"

    private let imageSize: CGFloat = 100

    var onPriceButtonTapped: ( (String) -> Void )?

    private lazy var contentContainer: UIView = {
        let container = UIView()
        return container
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Скидка 30% при заказе от 749 руб."
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private lazy var applyButton: UIButton = {
        let button = UIButton()
        let title = "Применить"
        var config = UIButton.Configuration.filled()
        config.title = title
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)]
        ))
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .red
        config.cornerStyle = .capsule
        config.contentInsets = .init(top: 5, leading: 15, bottom: 5, trailing: 15)
        button.configuration = config
        return button
    }()

    private lazy var offerImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "sale")
        imageView.image = image
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .darkGray.withAlphaComponent(0.4)
        layer.cornerRadius = 20
        layer.masksToBounds = true

        setupSubviews()
    }

    private func setupSubviews() {
        setupContentContainer()

        contentView.addSubviews(contentContainer)

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setupContentContainer() {

        contentContainer.addSubviews(titleLabel, applyButton, offerImageView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            titleLabel.widthAnchor.constraint(equalTo: contentContainer.widthAnchor, multiplier: 0.5),

            applyButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -10),
            applyButton.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),

            offerImageView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 10),
            offerImageView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -10),
            offerImageView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -10),

        ])
    }

    @objc func didTapPriceButton(_ sender: UIButton) {
        print("3344")
//        guard let price = sender.title(for: .normal)?.components(separatedBy: " ")[1] else { return }
//        onPriceButtonTapped?(price)
    }
}


//    func configureCell(pizza: Pizza) {
//        pizzaImageView.image = UIImage(named: pizza.imageName)
//        titleLabel.text = pizza.name
//        ingredientsLabel.text = pizza.ingredients
//        let price = "от \(pizza.price) ₽"
//        priceButton.setTitle(price, for: .normal)
//        if pizza.isHit {
//            hitImageView.isHidden = false
//        } else {
//            hitImageView.isHidden = true
//        }
//    }


//
