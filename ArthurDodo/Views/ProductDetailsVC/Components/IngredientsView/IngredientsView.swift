//
//  IngredientsView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 21.09.2024.
//

import UIKit

final class IngredientsView: UIView {

    // MARK: - Properties&Callbacks
    var onInfoButtonTapped: (() -> Void)?
    private let buttonSize: CGFloat = 24

    // MARK: - UI Properties
    private lazy var ingredientsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.regular16
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var infoButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "info.circle")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.semibold16
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IB Action
    @objc private func infoButtonTapped() {
        onInfoButtonTapped?()
    }

    // MARK: - Public methods
    func updateIngredients(_ ingredients: String) {
        ingredientsLabel.text = ingredients
    }

    func updateWeight(_ weight: Int) {
        let text = "\(weight) г"
        weightLabel.text = text
    }

    func getButtonFrame() -> CGRect {
        return infoButton.convert(infoButton.bounds, to: nil)
    }

    // MARK: - Private methods
    private func setupView() {
        backgroundColor = .darkGray.withAlphaComponent(0.4)
        layer.cornerRadius = 10
        layer.masksToBounds = true

        addSubviews(ingredientsLabel, infoButton, weightLabel)

        setupLayout()
    }

    private func setupLayout() {
        setupInfoLabelConstraints()
        setupInfoButtonConstraints()
        setupWeightLabelConstraints()
    }

    private func setupInfoLabelConstraints() {
        NSLayoutConstraint.activate([
            ingredientsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            ingredientsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            ingredientsLabel.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -10),
        ])
    }

    private func setupInfoButtonConstraints() {
        NSLayoutConstraint.activate([
            infoButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            infoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

    private func setupWeightLabelConstraints() {
        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 10),
            weightLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            weightLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weightLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
