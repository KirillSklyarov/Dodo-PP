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
    private let priceLabelHeight: CGFloat = 25
    private let cornerRadius: CGFloat = 10
    private let leftInset: CGFloat = 5
    private let rightInset: CGFloat = -5
    private let topInset: CGFloat = 5
    private let bottomInset: CGFloat = -5

    // MARK: - UI Properties
    private lazy var cellBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.backgroundGray
        view.layer.cornerRadius = cornerRadius
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
        label.font = AppFonts.bold14
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular12
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold12
        label.backgroundColor = AppColors.buttonGray
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = cornerRadius
        label.layer.masksToBounds = true
        label.heightAnchor.constraint(equalToConstant: priceLabelHeight).isActive = true
        return label
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
    func configCell(_ itemToAdd: Item) {
        itemImageView.image = UIImage(named: itemToAdd.imageName)
        titleLabel.text = itemToAdd.name
        setProductDetails(itemToAdd)
        setPrice(itemToAdd)
    }
}

// MARK: - Supporting methods
private extension AddToCartCollectionCell {
    func setProductDetails(_ item: Item) {
        let dough = Dough.basic.rawValue
        let size = Size.small.displayName.components(separatedBy: " ").dropFirst().joined(separator: " ")
        detailsLabel.text = "\(dough), \(size)"
    }

    func setPrice(_ item: Item) {
        let price = item.getCorrectPrice()
        let title = "\(price) ₽"
        priceLabel.text = title
    }
}

// MARK: - Setup UI
private extension AddToCartCollectionCell {
    func setupUI() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        contentView.addSubviews(cellBackgroundView, itemImageView, titleLabel, detailsLabel, priceLabel)

        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            cellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellBackgroundView.topAnchor.constraint(equalTo: itemImageView.centerYAnchor),

            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topInset),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),
            itemImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightInset),

            titleLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: topInset),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightInset),

            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topInset),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightInset),

            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomInset),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightInset)
        ])
    }
}
