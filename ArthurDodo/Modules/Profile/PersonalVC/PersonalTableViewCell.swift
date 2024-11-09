//
//  PersonalTableViewCell.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 11.10.2024.
//

import UIKit

final class PersonalTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = "PersonalTableViewCell"

    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 10
    private let bottomPadding: CGFloat = -10

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.grayFont
        label.font = AppFonts.regular18
        return label
    }()
    private lazy var dataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.regular18
        return label
    }()
    private lazy var switchLabel: UISwitch = {
        let switchLabel = UISwitch()
        switchLabel.isOn = false
        switchLabel.isHidden = true
        return switchLabel
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configureCell(title: String, data: String) {
        if title != "Разрешить уведомления" {
            titleLabel.text = title
            dataLabel.text = data
        } else {
            designPushCell(title, data)
        }
    }

    private func designPushCell(_ title: String, _ data: String) {
        titleLabel.text = title
        titleLabel.textColor = .white
        dataLabel.text = "Пуши, письма на почту, СМС"
        dataLabel.textColor = AppColors.grayFont
        switchLabel.isHidden = false
        if data == "false" {
            switchLabel.isOn = false
        } else {
            switchLabel.isOn = true
        }
    }
}

// MARK: - Setup UI
private extension PersonalTableViewCell {
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, dataLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 5

        let contentStack = UIStackView(arrangedSubviews: [labelsStack, switchLabel])
        contentStack.axis = .horizontal
        contentStack.alignment = .center

        contentView.addSubviews(contentStack)

        NSLayoutConstraint.activate([
            contentStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightPadding),
        ])
    }
}
