//
//  AddressListTableViewCell.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 12.10.2024.
//

import UIKit

final class AddressListTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = "AddressListTableViewCell"

    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 10
    private let bottomPadding: CGFloat = -10

    // MARK: - UI Properties
    private lazy var orangePoint: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "record.circle.fill")?.withTintColor(AppColors.buttonOrange, renderingMode: .alwaysOriginal)
        imageView.image = image
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.grayFont
        label.font = AppFonts.regular18
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
    func configureCell(title: String) {
        titleLabel.text = myAddresses.first?.name
    }
}

// MARK: - Setup UI
private extension AddressListTableViewCell {
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        let image = UIImage(systemName: "pencil")
        let accessoryImage = UIImageView(image: image)
        accessoryView = accessoryImage

        let contentStack = UIStackView(arrangedSubviews: [orangePoint, titleLabel])
        contentStack.axis = .horizontal

        contentView.addSubviews(contentStack)

        NSLayoutConstraint.activate([
            contentStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightPadding),
        ])
    }
}
