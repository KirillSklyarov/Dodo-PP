//
//  ProductCollectionCell.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import UIKit

final class ProductCollectionCell: UICollectionViewCell {

    static let identifier: String = "ProductCollectionCell"

    private lazy var pizzaImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "pizza")
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Карбонара"
        label.textColor = .white
        return label
    }()
    private lazy var ingredientsLabel: UILabel = {
        let label = UILabel()
        label.text = "Бекон, сыры чеддер и пармезан, моцарелла, томаты, красный лук, чеснок, фирменный соус альфредо, итальянские травы"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    private lazy var priceButton: UIButton = {
        let button = UIButton()
        button.setTitle("от 589 руб.", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray.withAlphaComponent(0.4)
        button.layer.cornerRadius = 16
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return button
    }()
    private lazy var hitImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "hit2")
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.isHidden = true
        return imageView
    }()

    private lazy var contentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear

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
        let stackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [titleLabel, ingredientsLabel])
            stack.axis = .vertical
            stack.spacing = 5
            return stack
        }()

        contentContainer.addSubviews(pizzaImageView, hitImageView, stackView, priceButton)

        NSLayoutConstraint.activate([
            pizzaImageView.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            pizzaImageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),

            hitImageView.trailingAnchor.constraint(equalTo: pizzaImageView.trailingAnchor),
            hitImageView.topAnchor.constraint(equalTo: pizzaImageView.topAnchor),

            stackView.topAnchor.constraint(equalTo: pizzaImageView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: pizzaImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -10),

            priceButton.leadingAnchor.constraint(equalTo: pizzaImageView.trailingAnchor, constant: 10),
            priceButton.bottomAnchor.constraint(equalTo: pizzaImageView.bottomAnchor),
        ])
    }

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

