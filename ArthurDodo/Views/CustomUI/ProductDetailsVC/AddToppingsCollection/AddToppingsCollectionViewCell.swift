//
//  AddToppingsCollectionViewCell.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 20.09.2024.
//

import UIKit

final class AddToppingsCollectionViewCell: UICollectionViewCell {

    static let identifier: String = "AddToppingsCollectionViewCell"

    private let imageSize: CGFloat = 60

    private lazy var toppingImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "tomato")
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "cheese"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "100 ₽"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()

    private lazy var chosenImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
        imageView.image = image
        imageView.isHidden = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func chooseTopping() {
        backgroundColor = .darkGray.withAlphaComponent(0.3)
        chosenImageView.isHidden = false
    }

    func hideTopping() {
        backgroundColor = .clear
        chosenImageView.isHidden = true
    }

    func getChosenToppingPrice() -> Int {
        let price = priceLabel.text?.components(separatedBy: " ").first ?? "0"
        return Int(String(price)) ?? 0
    }

    private func setupConstraints() {
        layer.cornerRadius = 10
        layer.masksToBounds = true

        let stack = UIStackView(arrangedSubviews: [toppingImageView, titleLabel, priceLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing

        contentView.addSubviews(stack, chosenImageView)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            chosenImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            chosenImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
    }

    func configCell(_ topping: Topping) {
        toppingImageView.image = UIImage(named: topping.imageName)
        titleLabel.text = topping.name
        priceLabel.text = "\(topping.price) ₽"
    }
}

