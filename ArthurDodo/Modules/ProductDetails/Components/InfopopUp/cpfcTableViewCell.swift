//
//  InfopopupTableViewCell.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 20.09.2024.
//

import UIKit

final class cpfcTableViewCell: UITableViewCell {

    static let identifier: String = "cpfcTableViewCell"

    var onPriceButtonTapped: ( (String) -> Void )?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()

    private lazy var cpfcValueLabel: UILabel = {
        let label = UILabel()
        label.text = "123"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubviews(titleLabel, cpfcValueLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            cpfcValueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cpfcValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    func configureCell(title: String, cpfcValue: String) {
        print("title \(title)")
        titleLabel.text = title
        cpfcValueLabel.text = cpfcValue
    }
}

