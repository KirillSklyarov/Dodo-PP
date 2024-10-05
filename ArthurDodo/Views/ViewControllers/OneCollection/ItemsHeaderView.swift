//
//  ItemsHeaderView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 05.10.2024.
//

import UIKit

final class ItemsHeaderView: UICollectionReusableView {

    static let identifier: String = "ItemsHeaderView"
    private let imageSize: CGFloat = 160
    private let buttonWidth: CGFloat = 100
    private let hitImageSize: CGFloat = 130


    private lazy var pizzaImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "pizza")
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Карбонара"
        label.font = AppFonts.bold20
        label.textColor = .white
        return label
    }()
    private lazy var ingredientsLabel: UILabel = {
        let label = UILabel()
        label.text = "Бекон, сыры чеддер и пармезан, моцарелла, томаты, красный лук, чеснок, фирменный соус альфредо, итальянские травы"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    private lazy var priceButton: UIButton = {
        let button = UIButton()
        button.setTitle("589 руб.", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    private func setupContentContainer() -> UIView {
        let container = UIView()

        let backView: UIView = {
            let view = UIView()
            view.backgroundColor = .systemPurple.withAlphaComponent(0.4)
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            view.layer.cornerRadius = self.frame.height / 2
            return view
        }()

        container.addSubviews(backView, pizzaImageView, titleLabel, ingredientsLabel, priceButton)

        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            backView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            pizzaImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            pizzaImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 30),

            titleLabel.topAnchor.constraint(equalTo: pizzaImageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),

            ingredientsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            ingredientsLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            ingredientsLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),

            priceButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5),
            priceButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
        ])

        return container
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
}
