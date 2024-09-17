//
//  OrderView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 24.09.2024.
//

import UIKit

final class OrderView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "1 товар на 549 ₽"
        label.textColor = .white
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    init(frame: CGRect = .zero, title: String) {
        super.init(frame: frame)
        configUI()
        titleLabel.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setNewData(_ countOfItems: Int, totalPrice: Int) {
        let newText = "\(countOfItems) товар на \(totalPrice) ₽"
        titleLabel.text = newText
    }

    // MARK: - Private Properties
    private func configUI() {
        addSubviews(titleLabel)
        setupLayout()
    }

    private func setupLayout() {
        setupTitleLabelConstraints()
    }

    private func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
