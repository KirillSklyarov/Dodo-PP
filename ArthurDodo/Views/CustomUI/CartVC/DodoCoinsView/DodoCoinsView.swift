//
//  DodoCoinsView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 26.09.2024.
//

import UIKit

final class DodoCoinsView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "1 товар"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        return label
    }()

    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = "1234 ₽"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        return label
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    init(frame: CGRect = .zero, title: String, value: String) {
        super.init(frame: frame)
        configUI()
        titleLabel.text = title
        valueLabel.text = value
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setNewCountValue(_ count: Int) {
        titleLabel.text = "\(count) товар"
    }

    func setTotalPrice(_ totalPrice: Int) {
        valueLabel.text = "\(totalPrice) ₽"
    }

    // MARK: - Private Properties
    private func configUI() {
        addSubviews(contentStack)
        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

