//
//  LegalSectionTableViewCell.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 11.10.2024.
//

import UIKit

final class LegalSectionTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = "LegalSectionTableViewCell"

    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 10
    private let bottomPadding: CGFloat = -10

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.regular20
        return label
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
    func configureCell(_ row: Int) {
        switch row {
        case 0: titleLabel.text = "Язык приложения"
        case 1: titleLabel.text = "Правовые документы"
        default: break
        }
    }
}

// MARK: - Setup UI
private extension LegalSectionTableViewCell {
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        let image = UIImage(systemName: "chevron.right")?.withTintColor(AppColors.grayFont, renderingMode: .alwaysOriginal)
        let chevronView = UIImageView(image: image)
        accessoryView = chevronView

        contentView.addSubviews(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightPadding),
        ])
    }
}

