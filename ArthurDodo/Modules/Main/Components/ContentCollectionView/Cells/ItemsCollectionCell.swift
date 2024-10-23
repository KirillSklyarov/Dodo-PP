//
//  ItemsCollectionCell.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import UIKit

final class ItemsCollectionCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier: String = "ProductCollectionCell"

    private let imageSize: CGFloat = 130
    private let hitImageSize: CGFloat = 30

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
    private lazy var priceButton = PriceGrayButton()
    private lazy var hitImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "hit2")
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: hitImageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: hitImageSize).isActive = true
        imageView.isHidden = true
        return imageView
    }()
    private lazy var detailsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, ingredientsLabel, priceButton])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        return stack
    }()

    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [pizzaImageView, detailsStackView])
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
        ingredientsLabel.text = item.ingredients
        priceButton.setPrice(item)
        setHitImage(item)
    }
}

// MARK: - Setup UI
private extension ItemsCollectionCell {
    func setupUI() {
        contentView.addSubviews(contentStackView)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - Supporting methods
private extension ItemsCollectionCell {
    func setHitImage(_ item: Item) {
        if item.isHit {
            hitImageView.isHidden = false
        } else {
            hitImageView.isHidden = true
        }
    }
}
