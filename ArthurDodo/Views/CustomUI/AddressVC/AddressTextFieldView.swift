//
//  addressTextFieldView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 13.10.2024.
//

import UIKit

final class AddressTextFieldView: UIView {

    // MARK: - Properties
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 10
    private let bottomPadding: CGFloat = -10

    private let viewHeight: CGFloat = 60

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.grayFont
        label.font = AppFonts.semibold14
        return label
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField()
        let placeholder = "Enter your address"
        textField.textColor = .white
        textField.font = AppFonts.semibold16
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.white])
        return textField
    }()
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, textField])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()

    // MARK: - Init
    init(_ title: AddressTextFieldType) {
        super.init(frame: .zero)
        titleLabel.text = title.rawValue
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureView(_ textFieldText: String) {
        textField.text = textFieldText
    }
}

// MARK: - Setup UI
private extension AddressTextFieldView {
    func setupUI() {
        layer.cornerRadius = 14
        layer.masksToBounds = true
        setBorder(AppColors.grayFont)
        addSubviews(contentStack)

        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: topPadding),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftPadding),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightPadding),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomPadding),

            heightAnchor.constraint(equalToConstant: viewHeight)
        ])
    }
}
