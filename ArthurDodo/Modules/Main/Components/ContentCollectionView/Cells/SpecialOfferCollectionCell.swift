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
        imageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold16
        label.textColor = .white
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private lazy var priceButton = PriceGrayButton()
    private lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, priceButton])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        return stack
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [pizzaImageView, textStack])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        return stack
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
    func configureCell(_ item: Item) {
        pizzaImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.name
        priceButton.setPrice(item)
    }
}

// MARK: - Setup UI
private extension SpecialOfferCollectionCell {
    func setupUI() {
        contentView.addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
