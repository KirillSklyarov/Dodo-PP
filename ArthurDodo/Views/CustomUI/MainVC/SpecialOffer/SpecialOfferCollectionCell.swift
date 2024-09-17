//
//  SpecialOfferCollectionCell.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 19.09.2024.
//

import UIKit

final class SpecialOfferCollectionCell: UICollectionViewCell {

    static let identifier: String = "SpecialOfferCollectionCell"

    var onPriceButtonTapped: ( (String) -> Void )?

    private lazy var pizzaImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "pizza")
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Карбонара"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private lazy var priceButton: UIButton = {
        let button = UIButton()
        button.setTitle("от 589 руб.", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray.withAlphaComponent(0.4)
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(didTapPriceButton), for: .touchUpInside)
        return button
    }()

    private lazy var contentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

            priceButton.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.85)
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
