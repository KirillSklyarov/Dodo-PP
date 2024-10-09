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

    var onPriceButtonTapped: ( (String) -> Void )?

    // MARK: - UI Properties
    private lazy var pizzaImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "pizza")
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Карбонара"
        label.font = AppFonts.semibold16
        label.textColor = .white
        return label
    }()
    private lazy var priceButton: UIButton = {
        let button = UIButton()
        button.setTitle("от 589 руб.", for: .normal)
        button.titleLabel?.font = AppFonts.regular14
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.buttonGray
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(didTapPriceButton), for: .touchUpInside)
        return button
    }()
    private lazy var contentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IB Action
    @objc func didTapPriceButton(_ sender: UIButton) {
        print("3344")
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
}

// MARK: - Setup UI
private extension SpecialOfferCollectionCell {
    func setupSubviews() {

        setupContentContainer()

        contentView.addSubviews(contentContainer)

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func setupContentContainer() {

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
}
