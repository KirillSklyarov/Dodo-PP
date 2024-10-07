//
//  ProductCollectionCell.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import UIKit

final class ProductCollectionCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier: String = "ProductCollectionCell"
    private let imageSize: CGFloat = 130
    private let buttonWidth: CGFloat = 100
    private let hitImageSize: CGFloat = 30
    private let padding: CGFloat = 10

    // MARK: - UI Properties
    private lazy var pizzaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    private lazy var ingredientsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = AppFonts.regular12
        label.numberOfLines = 0
        return label
    }()
    private lazy var priceButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = AppFonts.bold14
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.buttonGray
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = true
        button.heightAnchor.constraint(equalToConstant: buttonWidth / 4).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        return button
    }()
    private lazy var hitImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "hit2")
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: hitImageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: hitImageSize).isActive = true
        imageView.isHidden = true
        return imageView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configureCell(pizza: FoodItems) {
        pizzaImageView.image = UIImage(named: pizza.imageName)
        titleLabel.text = pizza.name
        ingredientsLabel.text = pizza.ingredients

        var itemPrice = pizza.itemSize[.medium]?.price.description ?? ""
        if let pizza = pizza as? Pizza {
            itemPrice = pizza.itemSize[.small]?.price.description ?? ""
        }

        let price = "от \(itemPrice) ₽"
        priceButton.setTitle(price, for: .normal)

        if pizza.isHit {
            hitImageView.isHidden = false
        } else {
            hitImageView.isHidden = true
        }
    }
}

// MARK: - SetupLayout
private extension ProductCollectionCell {
    func setupUI() {
        backgroundColor = .clear

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
        let contentContainer: UIView = {
            let view = UIView()
            view.backgroundColor = .clear
            view.layer.cornerRadius = 10
            return view
        }()

        let stackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [titleLabel, ingredientsLabel, priceButton])
            stack.axis = .vertical
            stack.spacing = 10
            stack.distribution = .fill
            stack.alignment = .leading
            return stack
        }()

        stackView.setBorder()

        contentContainer.addSubviews(pizzaImageView, hitImageView, stackView)

        NSLayoutConstraint.activate([
            pizzaImageView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: padding),
            pizzaImageView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -padding),
            pizzaImageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),

            hitImageView.trailingAnchor.constraint(equalTo: pizzaImageView.trailingAnchor),
            hitImageView.topAnchor.constraint(equalTo: pizzaImageView.topAnchor),

            stackView.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: pizzaImageView.trailingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -padding),
        ])
        return contentContainer
    }
}
