//
//  ToppingsCollectionCell.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 26.09.2024.
//

import UIKit

final class AddToCartCollectionCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier: String = "AddToCartCollectionCell"
    private let imageSize: CGFloat = 100
    private let buttonHeight: CGFloat = 25

    // MARK: - UI Properties
    private lazy var cellBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray.withAlphaComponent(0.4)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "pizza")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    private lazy var priceButton: UIButton = {
        let button = UIButton()
        let title = ""

        var config = UIButton.Configuration.filled()
        config.title = title
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)]
        ))
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .darkGray.withAlphaComponent(0.4)
        config.cornerStyle = .capsule

        button.configuration = config
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        return button
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
    func configCell(_ pizzaToAdd: Pizza) {
        itemImageView.image = UIImage(named: pizzaToAdd.imageName)
        titleLabel.text = pizzaToAdd.name
        let dough = Dough.basic.rawValue
        let size = Size.small.rawValue.components(separatedBy: " ").dropFirst().joined(separator: " ")
        weightLabel.text = "\(dough), \(size)"
        let price = pizzaToAdd.size[.small]?.price ?? 0
        let title = "\(price) ₽"

        priceButton.configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold)])
        )
    }

    // MARK: - Private methods
    private func setupUI() {
        layer.cornerRadius = 10
        layer.masksToBounds = true

        contentView.addSubviews(cellBackgroundView, itemImageView, titleLabel, weightLabel, priceButton)

        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            cellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellBackgroundView.topAnchor.constraint(equalTo: itemImageView.centerYAnchor),

            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            itemImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

            titleLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

            weightLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            weightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            weightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

            priceButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            priceButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            priceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
    }

    func cellSelected() {
//        priceButton.isHidden = true
//        countStepper.isHidden = false
    }
}



//
//    func hideTopping() {
//        backgroundColor = .clear
//        chosenImageView.isHidden = true
//    }

//    func getChosenToppingPrice() -> Int {
//        let price = priceLabel.text?.components(separatedBy: " ").first ?? "0"
//        return Int(String(price)) ?? 0
//    }
