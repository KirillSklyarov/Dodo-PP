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

    private let imageSize: CGFloat = 25
    private let editAddressButtonSize: CGFloat = 25

    var onEditAddressButtonTapped: (() -> Void)?

    // MARK: - UI Properties
    private lazy var orangePoint: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "record.circle.fill")?.withTintColor(AppColors.buttonOrange, renderingMode: .alwaysOriginal)
        imageView.image = image
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.grayFont
        label.font = AppFonts.semibold20
        return label
    }()
    private lazy var editAddressButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "pencil")?.withTintColor(AppColors.buttonGray, renderingMode: .alwaysOriginal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: editAddressButtonSize, height: editAddressButtonSize)
        button.addTarget(self, action: #selector(editAddressButtonTapped), for: .touchUpInside)
        return button
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
        titleLabel.text = title
    }

    @objc private func editAddressButtonTapped() {
        onEditAddressButtonTapped?()
    }
}

// MARK: - Setup UI
private extension AddressListTableViewCell {
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        accessoryView = editAddressButton

        let contentStack = UIStackView(arrangedSubviews: [orangePoint, titleLabel])
        contentStack.axis = .horizontal
        contentStack.spacing = 10

        contentView.addSubviews(contentStack)

        NSLayoutConstraint.activate([
            contentStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightPadding),
        ])
    }
}
