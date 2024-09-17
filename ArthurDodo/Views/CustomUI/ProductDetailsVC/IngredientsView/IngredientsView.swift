//
//  IngredientsView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 21.09.2024.
//

import UIKit

final class IngredientsView: UIView {

    var onInfoButtonTapped: (() -> Void)?

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Моцарелла, чеддер, пармезан, соус альфредо"
        return label
    }()
    lazy var infoButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "info.circle")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "300 г"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateIngredients(_ ingredients: String) {
        infoLabel.text = ingredients
    }

    func updateWeight(_ weight: Int) {
        let text = "\(weight) г"
        weightLabel.text = text
    }

    private func setupView() {
        backgroundColor = .darkGray
        layer.cornerRadius = 10
        layer.masksToBounds = true

        addSubviews(infoLabel, infoButton, weightLabel)

        setupLayout()

    }

    func getButtonFrame() -> CGRect {
        return infoButton.frame
    }

    private func setupLayout() {
        setupInfoLabelConstraints()
        setupInfoButtonConstraints()
        setupWeightLabelConstraints()
    }


    private func setupInfoLabelConstraints() {
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
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
            weightLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            weightLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            weightLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weightLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    @objc private func infoButtonTapped() {
        onInfoButtonTapped?()
    }
}
