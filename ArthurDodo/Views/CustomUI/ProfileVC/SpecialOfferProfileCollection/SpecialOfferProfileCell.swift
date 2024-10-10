//
//  SpecialOfferProfileCell.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 10.10.2024.
//

import UIKit

final class SpecialOfferProfileCell: UICollectionViewCell {

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
    private lazy var specialOfferImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: coinsImageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: coinsImageSize).isActive = true
        return imageView
    }()
    private lazy var nameOfOfferLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bold40
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    private lazy var detailsOfOfferLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bold40
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bold40
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    private lazy var applyButton: UIButton = {
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
        let data = testCoinsOrdersModel
        let item = indexPath.item

        containerView.backgroundColor = AppColors.dodoCoinsBlue
        let image = UIImage(named: "dodoCoinsImage")
        specialOfferImageView.image = image
        let dodoCoins = data.dodoCoins.description
//        titleLabel.text = dodoCoins
        setButtonTitle("додокоины")
    }

    func setButtonTitle(_ title: String) {
        applyButton.configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .foregroundColor: UIColor.white,
            .font: AppFonts.bold14])
        )
    }
}

// MARK: - Setup UI
private extension SpecialOfferProfileCell {
    func setupConstraints() {

        containerView.addSubviews(specialOfferImageView, nameOfOfferLabel, detailsOfOfferLabel, dateLabel, applyButton)

        NSLayoutConstraint.activate([
            specialOfferImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topPadding),
            specialOfferImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: rightPadding),

            nameOfOfferLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topPadding),
            nameOfOfferLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: leftPadding),

            detailsOfOfferLabel.topAnchor.constraint(equalTo: nameOfOfferLabel.topAnchor, constant: topPadding),
            detailsOfOfferLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leftPadding),

            dateLabel.topAnchor.constraint(equalTo: detailsOfOfferLabel.topAnchor, constant: topPadding),
            dateLabel.leadingAnchor.constraint(equalTo: detailsOfOfferLabel.leadingAnchor, constant: leftPadding),

            applyButton.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: bottomPadding),
            applyButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leftPadding),
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

