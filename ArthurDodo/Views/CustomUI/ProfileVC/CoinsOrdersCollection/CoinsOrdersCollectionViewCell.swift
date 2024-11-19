//
//  CoinsOrdersCollectionViewCell.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 10.10.2024.
//

import UIKit

final class CoinsOrdersCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier: String = "CoinsOrdersCollectionViewCell"
    private let coinsImageSize: CGFloat = 70
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 10
    private let bottomPadding: CGFloat = -10

    private let subTitleButtonWidth: CGFloat = 70
    private let subTitleButtonHeight: CGFloat = 30

    // MARK: - UI Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.backgroundColor = AppColors.backgroundGray
        return view
    }()
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: coinsImageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: coinsImageSize).isActive = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bold40
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    private lazy var subTitleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .white.withAlphaComponent(0.2)
        config.cornerStyle = .capsule
        button.configuration = config
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configureCell(_ indexPath: IndexPath) {
        let data = testCoinsOrders
        let item = indexPath.item

        switch item {
        case 0: designDodoCoinsCell(data)
        case 1: designOrdersCell(data)
        case 2: designAddressCell(data)
        default: break
        }
    }

    func designDodoCoinsCell(_ data: DodoCoinsOrders) {
        containerView.backgroundColor = AppColors.dodoCoinsBlue
        let image = UIImage(named: "dodoCoinsImage")
        coverImageView.image = image
        let dodoCoins = data.dodoCoins.description
        titleLabel.text = dodoCoins
        setButtonTitle("додокоины")
    }

    func designOrdersCell(_ data: DodoCoinsOrders) {
        let image = UIImage(named: "dodoCoinsImage")
        coverImageView.image = image
        titleLabel.text = "Mои заказы"
        titleLabel.font = AppFonts.bold22
        let countOfOrders = data.orders.description
        setButtonTitle("\(countOfOrders) заказов")
    }

    func designAddressCell(_ data: DodoCoinsOrders) {
        let image = UIImage(named: "mapPin")
        coverImageView.image = image
        titleLabel.text = "Адреса доставки"
        titleLabel.numberOfLines = 0
        titleLabel.font = AppFonts.bold22
        let countOfAddress = data.address.count.description
        setButtonTitle("\(countOfAddress) адрес")
    }

    func setButtonTitle(_ title: String) {
        subTitleButton.configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .foregroundColor: UIColor.white,
            .font: AppFonts.bold14])
        )
    }
}

// MARK: - Setup UI
private extension CoinsOrdersCollectionViewCell {
    func setupConstraints() {

        containerView.addSubviews(coverImageView, titleLabel, subTitleButton)

        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: leftPadding),
            coverImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: topPadding),

            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leftPadding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: rightPadding),
            titleLabel.bottomAnchor.constraint(equalTo: subTitleButton.topAnchor, constant: bottomPadding),

            subTitleButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leftPadding),
            subTitleButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: bottomPadding)
        ])

        contentView.addSubviews(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

