//
//  ItemsHeaderView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 05.10.2024.
//

import UIKit

<<<<<<< HEAD
final class ItemsHeaderView: UICollectionReusableView {

=======
final class ItemsHeaderView: UICollectionViewCell {

    // MARK: - Properties
>>>>>>> testMy
    static let identifier: String = "ItemsHeaderView"
    private let imageSize: CGFloat = 160
    private let buttonWidth: CGFloat = 100
    private let hitImageSize: CGFloat = 130

<<<<<<< HEAD

    private lazy var pizzaImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "pizza")
        imageView.image = image
=======
    // MARK: - UI Properties
    private lazy var pizzaImageView: UIImageView = {
        let imageView = UIImageView()
>>>>>>> testMy
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()
<<<<<<< HEAD
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Карбонара"
=======
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
>>>>>>> testMy
        label.font = AppFonts.bold20
        label.textColor = .white
        return label
    }()
    private lazy var ingredientsLabel: UILabel = {
        let label = UILabel()
<<<<<<< HEAD
        label.text = "Бекон, сыры чеддер и пармезан, моцарелла, томаты, красный лук, чеснок, фирменный соус альфредо, итальянские травы"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
=======
        label.textColor = .gray
        label.font = AppFonts.regular14
>>>>>>> testMy
        label.numberOfLines = 0
        return label
    }()
    private lazy var priceButton: UIButton = {
        let button = UIButton()
<<<<<<< HEAD
        button.setTitle("589 руб.", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
=======
        button.titleLabel?.font = AppFonts.bold14
>>>>>>> testMy
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

<<<<<<< HEAD
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
=======
    var gradientLayer: CAGradientLayer?

    private lazy var backView: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = frame.height / 2
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
>>>>>>> testMy
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

<<<<<<< HEAD
    func setTitle(_ title: String) {
        titleLabel.text = title
=======
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }

    // MARK: - Public methods
    func configHeader(_ item: FoodItems) {
        let image = UIImage(named: item.imageName)
        pizzaImageView.image = image
        titleLabel.text = item.name
        ingredientsLabel.text = item.ingredients
        let price = item.itemSize[.medium]?.price ?? 0
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
        configGradient()

        contentView.addSubviews(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
>>>>>>> testMy
    }

    private func setupContentContainer() -> UIView {
        let container = UIView()
<<<<<<< HEAD

        let backView: UIView = {
            let view = UIView()
            view.backgroundColor = .systemPurple.withAlphaComponent(0.4)
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            view.layer.cornerRadius = self.frame.height / 2
            return view
        }()
=======
        container.translatesAutoresizingMaskIntoConstraints = false
>>>>>>> testMy

        container.addSubviews(backView, pizzaImageView, titleLabel, ingredientsLabel, priceButton)

        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
<<<<<<< HEAD
            backView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
=======
            backView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            backView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
>>>>>>> testMy
            backView.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            pizzaImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            pizzaImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 30),

            titleLabel.topAnchor.constraint(equalTo: pizzaImageView.bottomAnchor, constant: 5),
<<<<<<< HEAD
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),

            ingredientsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            ingredientsLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            ingredientsLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),

            priceButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5),
            priceButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
=======
            titleLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),

            ingredientsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            ingredientsLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            ingredientsLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),

            priceButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -5),
            priceButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
>>>>>>> testMy
        ])

        return container
    }
<<<<<<< HEAD

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
=======
>>>>>>> testMy
}
