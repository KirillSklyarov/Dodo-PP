//
//  ItemsHeaderView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 05.10.2024.
//

import UIKit

final class ItemsHeaderView: UICollectionViewCell {

    // MARK: - Properties
    static let identifier: String = "ItemsHeaderView"
    private let imageSize: CGFloat = 160
    private let buttonWidth: CGFloat = 100
    private let hitImageSize: CGFloat = 130

    // MARK: - UI Properties
    private lazy var pizzaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bold20
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    private lazy var ingredientsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = AppFonts.regular14
        label.numberOfLines = 0
        return label
    }()
    private lazy var priceButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = AppFonts.bold14
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray.withAlphaComponent(0.4)
        button.layer.cornerRadius = 16
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        return button
    }()
    private lazy var hitImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "hit2")
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: hitImageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: hitImageSize).isActive = true
        imageView.isHidden = true
        return imageView
    }()
    private lazy var backView: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = frame.height / 2
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var gradientLayer: CAGradientLayer?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configGradient()
        gradientLayer?.frame = bounds
    }

    // MARK: - Public methods
    func configHeader(_ item: Item) {
        let image = UIImage(named: item.imageName)
        pizzaImageView.image = image
        titleLabel.text = item.name
        ingredientsLabel.text = item.ingredients
        let price = item.itemSize.medium?.price ?? 0
        priceButton.setTitle("\(price) ₽", for: .normal)
    }

    // MARK: - Private methods
    private func configGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor, UIColor.systemPurple.cgColor, AppColors.backgroundGray.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        backView.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }

    private func configUI() {
        let container = setupContentContainer()

        addSubviews(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupContentContainer() -> UIView {
        let container = UIView()

        container.addSubviews(backView, pizzaImageView, titleLabel, ingredientsLabel, priceButton)

        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            backView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            backView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            backView.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            pizzaImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            pizzaImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 30),

            titleLabel.topAnchor.constraint(equalTo: pizzaImageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),

            ingredientsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            ingredientsLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            ingredientsLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),

            priceButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -5),
            priceButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
        ])

        return container
    }
}
