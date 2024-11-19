//
//  CartSpOfferCollectionCell.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 24.09.2024.
//

import UIKit

final class CartSpOfferCollectionCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier: String = "CoinsOrdersCollectionViewCell"
    private let spOfferImageSize: CGFloat = 70
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 10
    private let bottomPadding: CGFloat = -10
    private var halfWidth: CGFloat { self.frame.size.width / 2 - leftPadding + rightPadding }

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
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: halfWidth).isActive = true
        return imageView
    }()
    private lazy var nameOfOfferLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold14
        label.textColor = AppColors.grayFont
        label.textAlignment = .left
        label.widthAnchor.constraint(equalToConstant: halfWidth).isActive = true
        label.numberOfLines = 0
        return label
    }()
    private lazy var detailsOfOfferLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold16
        label.textColor = .white
        label.textAlignment = .left
        label.widthAnchor.constraint(equalToConstant: halfWidth).isActive = true
        label.numberOfLines = 0
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular14
        label.textColor = AppColors.grayFont
        label.textAlignment = .left
        return label
    }()
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        let title = "Применить"
        var config = UIButton.Configuration.filled()
        config.title = title
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)]
        ))
        config.baseForegroundColor = .white
        config.baseBackgroundColor = AppColors.buttonOrange
        config.cornerStyle = .capsule
        button.configuration = config
        button.isUserInteractionEnabled = false
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
    func configureCell(_ item: SpecialOfferProfile) {
        nameOfOfferLabel.text = item.name.uppercased()
        detailsOfOfferLabel.text = item.details
        dateLabel.text = item.date
        let image = UIImage(named: item.imageName)
        specialOfferImageView.image = image
    }
}

// MARK: - Setup UI
private extension CartSpOfferCollectionCell {
    func setupConstraints() {

        containerView.addSubviews(specialOfferImageView, nameOfOfferLabel, detailsOfOfferLabel, dateLabel, applyButton)

        NSLayoutConstraint.activate([
            specialOfferImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topPadding),
            specialOfferImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: bottomPadding),

            specialOfferImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: rightPadding),

            nameOfOfferLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topPadding),
            nameOfOfferLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leftPadding),

            detailsOfOfferLabel.topAnchor.constraint(equalTo: nameOfOfferLabel.bottomAnchor, constant: topPadding),
            detailsOfOfferLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leftPadding),

            dateLabel.topAnchor.constraint(equalTo: detailsOfOfferLabel.bottomAnchor, constant: topPadding),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leftPadding),

            applyButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: bottomPadding),
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
